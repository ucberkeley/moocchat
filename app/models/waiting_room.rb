class WaitingRoom < ActiveRecord::Base

  # A +WaitingRoom+ collects arriving learners until the next peer activity
  # is scheduled to begin.  When that time comes, the learners in the
  # waiting room are split up into groups and the waiting room is
  # emptied.

  # There is at most one waiting room for each
  # <ActivitySchema,Condition> pair.
  belongs_to :condition, :dependent => :destroy
  belongs_to :activity_schema, :dependent => :destroy
  validates :condition_id, :uniqueness => {:scope => :activity_schema_id}
  validates_associated :condition
  validates_associated :activity_schema
  #
  # In terms of the app architecture, the waiting room actually collects
  # +Task+s, which include the learner, activity schema, and condition.
  # When learners are grouped, people who started earlier have priority.
  #
  has_many :tasks, :dependent => :nullify, :order => :created_at

  # It is an error to try to enqueue (put in a waiting room) the same
  # task more than once. 
  class WaitingRoom::TaskAlreadyWaitingError < RuntimeError ; end

  # Sentinel value meaning you're not assigned to any chat group
  CHAT_GROUP_NONE = 'NONE'

  # Any time a new +WaitingRoom+ is created, its expiration time is automatically set
  # to the next 'boundary' of when the experiment repeats.
  before_create do
    self.expires_at ||= compute_expiration_time
  end

  # When the class method +process_all!+ is called, all waiting rooms
  # are checked to see if any of them have an expired timer, and
  # +WaitingRoom#process!+ is called on any ready instances.  The call
  # to +process_all!+ can be triggered by a cron job or by connecting
  # the method to an authenticated endpoint.
  #

  public

  # Add a task to a waiting room.
  # If the waiting room for this condition and activity doesn't exist,
  # create it.
  # Returns the number of seconds until the waiting room should be processed.
  def self.add task
    wr = WaitingRoom.
      find_or_create_by_activity_schema_id_and_condition_id!(
      task.activity_schema_id, task.condition_id)
    wr.add task
    return wr.expires_at - Time.zone.now
  end

  # Wake up and check all waiting rooms.  For any waiting rooms whose +expired_at+ now
  # matches or exceeds the current time, process it, then destroy it.
  def self.process_all!
    WaitingRoom.where(['expires_at <= ?', Time.zone.now]).each do |wr|
      wr.process
    end
  end

  # Add a task to *this* waiting room.  Called by +WaitingRoom.add+.

  def add task
    if tasks.include? task
      raise TaskAlreadyWaitingError
    else
      tasks << task
    end
  end

  # Process a waiting room.  Forms as many groups as possible of size
  #  +Condition#preferred_group_size+, then as many as possible of size
  #  +Condition#minimum_group_size+; the rest stay in the waiting room.  Kicking
  # someone out is done by placing the sentinel value +CHAT_GROUP_NONE+ as the
  # chat group ID for those learners' tasks.
  def process
    transaction do
      # create as many groups of the preferred size as we can...
      leftovers = create_groups_of(condition.preferred_group_size, tasks)
      # if there are leftover people, create groups of the minimum size (which could be singletons)...
      rejects = leftovers.empty? ? [ ] : create_groups_of(condition.minimum_group_size, leftovers)
      # if there are any singletons now, they're rejects
      rejects.each { |t| t.assign_to_chat_group CHAT_GROUP_NONE }
      self.destroy
    end
  end

  private

  # Peel off task groups of a specific size; return the set of leftovers
  def create_groups_of num, task_list
    task_list.each_slice(num) do |set_of_tasks|
      return set_of_tasks if set_of_tasks.length < num # ignore leftovers
      create_group_from set_of_tasks
    end
    # we never returned from inside the loop, so there must be no leftovers
    []
  end  

  # Create a chat group from a list of tasks
  def create_group_from task_list # :nodoc:
    group_name = task_list.map(&:id).sort.map(&:to_s).join(',')
    task_list.each { |t| t.assign_to_chat_group group_name }
  end

  # Compute the expiration date of a waiting room that is being created.
  # The +ActivitySchema+ knows the start and end times and how often the waiting rooms empty.
  # Since the repeat interval must be an integral divisor of 60 minutes, we just set the
  # expiration time to round *strictly up* to the nearest minute-boundary of a repeat, that is,
  # if the repeat is every 6 minutes and it's currently 16 after the hour, round up to 18.
  def compute_expiration_time
    repeat = activity_schema.starts_every
    minutes_to_add = repeat - (Time.now.min % repeat)
    (Time.zone.now + minutes_to_add.minutes).change(:sec => 0)
  end

end
