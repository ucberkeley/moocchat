class Task < ActiveRecord::Base

  # Ties together a +Learner+, +ActivitySchema+, and +Condition+ into
  # a task that steps the learner through a sequence of pages.

  belongs_to :activity_schema
  belongs_to :learner
  belongs_to :condition
  validates_associated :activity_schema
  validates_associated :learner
  validates_associated :condition

  # In most experiments, at some point a +Task+ will be added to a
  # +WaitingRoom+, which collects learners and forms groups from them.
  belongs_to :waiting_room

  # The sequence state is tracked by an internal private class
  # +Task::Sequencer+, certain elements of which are exposed via
  # delegation as read-only attributes of this class.

  require_relative './task/task_sequencer'
  serialize :sequence_state, Sequencer

  # Tasks log interesting events to an +EventLog+.
  has_one :event_log	

  attr_accessible :condition, :learner, :activity_schema, :completed, :original_chat_group, :chat_group, :sequence_state

  # Exception raised when learner tries to create task for an activity that
  # isn't open yet
  class ActivityNotOpenError < RuntimeError ; end
  # Exception raised when +learner_index+ is called but this task's learner
  # isn't in the specified chat group channel
  class LearnerNotInGroupError < RuntimeError ; end
  
  serialize :user_state, Hash

  # For testing purposes, an admin or "Test learner" can bypass the
  # timer on the welcome page and force group formation to happen RIGHT NOW.
  delegate :force_group_formation_now!, :to => :waiting_room

  # Create a new task from a hash that includes a +condition_id+,
  # +activity_schema_id+, and +learner_name+.
  #
  # +condition_id+ and +activity_schema_id+ must be the primary keys
  # of an existing valid +Condition+ and +ActivitySchema+ respectively.
  #
  # +learner_name+ is the learner's nym; if it doesn't exist, an instance
  # of +Learner+ will be created.
 
  def self.create_from_params(params)
    act = params[:activity_schema_id]
    cond = params[:condition_id]
    if(act.is_a?(Hash) && cond.is_a?(Hash)) #suggested by github to handle collection select(which returns {:id => value} rather than value)
      act = act[:id]
      cond = cond[:id]
    end
    condition = Condition.find  cond
    activity_schema = ActivitySchema.find act
    learner = Learner.find_or_create_by_name! params[:learner_name]

    raise ActivityNotOpenError unless activity_schema.enabled?
    
    @t = Task.create!(
      :condition => condition,
      :learner => learner,
      :completed => false,
      :original_chat_group => nil,
      :chat_group => nil,
      :activity_schema => activity_schema,
      :sequence_state => Sequencer.new(:body_repeat_count => condition.body_repeat_count, :num_questions => activity_schema.num_questions)
      )
  end

  # The counter starts at 0 on the first page of the task and
  # counts by 1 as each new page is visited.
  delegate :counter, :to => :sequence_state

  # Which question from the +ActivitySchema+ is to be served next (0-based)
  delegate :question_counter, :to => :sequence_state

  # Where we are in the condition flow (prologue, body, epilogue)
  delegate :where, :to => :sequence_state

  # Subcounter of where we are within the prologue/body/etc.
  delegate :subcounter, :to => :sequence_state
  
  # Form chat group ("channel") name from tasks associated with this group
  def self.chat_group_name_from_tasks(tasks)
    tasks.map(&:id).sort.map(&:to_s).join(',')
  end

  # Given a chat group channel name (string), return numeric index (0, 1, ...)
  # of which learner is represented by THIS task.
  def learner_index
    group_tasks.index(self.id.to_i) ||
      raise(LearnerNotInGroupError,
      "Chat group #{chat_group} does not include task id #{self.id}")
  end

  # Retrieve user state for all tasks in my chat group, including my state
  def user_state_for_all
    begin
      group_tasks.map { |task_id| Task.find(task_id).user_state }
    rescue ActiveRecord::RecordNotFound => e
      raise LearnerNotInGroupError, "Can't find user state for task: #{e.message}"
    end
  end

  def group_tasks # :nodoc:
    case chat_group
    when blank?
      raise LearnerNotInGroupError, "Learner was never assigned to a group"
    when WaitingRoom::CHAT_GROUP_NONE
      raise LearnerNotInGroupError, "Learner was kicked out of Waiting Room"
    else
      chat_group.to_s.split(',').map(&:to_i)
    end
  end

  # Returns the +Template+ object that should be rendered for the
  # current page in the task sequence.
  def current_page
    page = sequence_state.current_page(self.condition)
    # the above call may modify sequence_state's internal state,
    # so we have to save the task to serialize it
    save!
    page
  end

  # Advance to the next page of the task.  Returns that page, or +nil+
  # if end of task has been reached.
  def next_page!
    sequence_state.next_page
    save!
    self.reload.current_page
  end

  # Advance to next question
  def next_question!
    sequence_state.next_question
    save!
    reload
  end

  def remove_from_chat_group(task_id)
    chat_group_ids = self.group_tasks
    if chat_group_ids.include? task_id   # Ignore if already removed
      chat_group_ids.delete(task_id)
      chat_group = chat_group_ids.map { |task_id| Task.find(task_id) }
      new_group_name = Task.chat_group_name_from_tasks(chat_group)
      self.assign_to_chat_group(new_group_name, false)
    end
  end

  # Assign this task to a particular chat group.  As a side effect, this removes the task
  # from its waiting room.
  def assign_to_chat_group(group, original_assignment)
    self.chat_group = group
    if original_assignment then self.original_chat_group = self.chat_group end
    self.waiting_room = nil
    self.save!
  end

  # Returns the next question to be consumed for the task.
  def current_question
    activity_schema.questions[question_counter]
  end

  # Log an interesting event related to this task. Denormalize the various
  # foreign key fields - see README.rdoc for details.  Some event names
  # require a value; enforcing that is left to the +EventLog+ validations.
  def log(name, value='')
    EventLog.create!(
      :name => name.to_sym,
      :value => value,
      :task => self,
      :learner => self.learner,
      :activity_schema => self.activity_schema,
      :condition => self.condition,
      :counter => self.counter,
      :subcounter => self.subcounter,
      :question_counter => self.question_counter,
      :question => self.current_question,
      :chat_group => self.chat_group)
  end

end


