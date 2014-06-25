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

  attr_accessible :condition, :learner, :activity_schema, :completed, :chat_group, :sequence_state

  class ActivityNotOpenError < RuntimeError ; end

  serialize :user_state, Hash



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
      :chat_group => nil,
      :activity_schema => activity_schema,
      :sequence_state => Sequencer.new(activity_schema.num_questions)
      )
  end

  # The counter starts at 1 on the first page of the task and
  # counts by 1 as each new page is visited.
  delegate :counter, :to => :sequence_state

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

  # Assign this task to a particular chat group.  As a side effect, this removes the task
  # from its waiting room.
  def assign_to_chat_group(group)
    self.chat_group = group
    self.waiting_room = nil
    self.save!
  end

  # Returns the next question to be consumed for the task.
  def current_question
    Question.new
  end
end


