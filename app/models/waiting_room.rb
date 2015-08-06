class WaitingRoom < ActiveRecord::Base

  # A +WaitingRoom+ collects arriving learners until the next peer activity
  # is scheduled to begin.  When that time comes, the learners in the
  # waiting room are split up into groups and the waiting room is
  # emptied.

  # There is at most one waiting room for each
  # <ActivitySchema,Condition> pair.
  belongs_to :condition
  belongs_to :activity_schema
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

  # The number of seconds before the timer expires that a heartbeat is sent
  @heartbeat_seconds = 15

  # Any time a new +WaitingRoom+ is created, its expiration time is automatically set
  # to the next 'boundary' of when the experiment repeats.
  before_create do
    self.expires_at ||= activity_schema.compute_expiration_time
  end

  # When the class method +process_all!+ is called, all waiting rooms
  # are checked to see if any of them have an expired timer, and
  # +WaitingRoom#process!+ is called on any ready instances.  The call
  # to +process_all!+ can be triggered by a cron job or by connecting
  # the method to an authenticated endpoint.
  #

  public

  def self.heartbeat_seconds
    @heartbeat_seconds
  end

  # Add a task to a waiting room.
  # If the waiting room for this condition and activity doesn't exist,
  # create it.
  # Returns the number of seconds until the waiting room should be processed.
  def self.add task
    wr = WaitingRoom.
      find_or_create_by_activity_schema_id_and_condition_id!(
      task.condition.primary_activity_schema_id, task.condition_id)

    current_time = Time.zone.now
    # If more than a minute has passed since this room expired, destroy it and make a new one
    if current_time > wr.expires_at + 60 then
      wr.destroy
      return self.add task
    end

    wr.add task
    return wr.timer_until(task)
  end

  # Add a task to *this* waiting room.  Called by +WaitingRoom.add+.

  def add task
    if tasks.include? task
      raise TaskAlreadyWaitingError
    else
      tasks << task
    end
  end

  # Admins can force waiting room to process tasks immediately (ie on
  # next call to TasksController#join_groups action).
  def force_group_formation_now!
    self.update_attribute(:expires_at, 1.second.ago)
  end

  # Wake up and check all waiting rooms.  For any waiting rooms whose +expired_at+ now
  # matches or exceeds the current time, process it, then destroy it.
  def self.process_all!
    transaction do
      WaitingRoom.where(['expires_at <= ?', Time.zone.now]).each do |wr|
        wr.process
      end
    end
  end

  # Process a waiting room.  Forms as many groups as possible of size
  #  +Condition#preferred_group_size+, then as many as possible of size
  #  +Condition#minimum_group_size+; the rest stay in the waiting room.  Kicking
  # someone out is done by placing the sentinel value +CHAT_GROUP_NONE+ as the
  # chat group ID for those learners' tasks.
  def process
    self.remove_disconnected
    # create as many groups of the preferred size as we can...
    leftovers = create_groups_of(condition.preferred_group_size, tasks)
    # For this run we want to create groups larger than the minimum size if possible
    (condition.preferred_group_size - 1).downto(condition.minimum_group_size + 1) { |size|
      leftovers = leftovers.empty? ? [ ] : create_groups_of(size, leftovers)
    }
    # if there are leftover people, create groups of the minimum size (which could be singletons)...
    rejects = leftovers.empty? ? [ ] : create_groups_of(condition.minimum_group_size, leftovers)
    # if there are any singletons now, they're rejects
    rejects.each { |t| t.assign_to_chat_group(CHAT_GROUP_NONE, true) }
    self.destroy
  end

  def remove_disconnected
    current_time = Time.zone.now
    # Add 10 seconds to give some buffer room for network delay in the join_group call
    self.tasks = self.tasks.select{ |t| !t.last_heartbeat.nil? && current_time - t.last_heartbeat < WaitingRoom.heartbeat_seconds + 10 }
  end

  # Stretch out timer so users don't all bang on the server at once to
  # join a group.  In general, try to avoid more than MAX_USERS every 
  # SERVICE_TIME_IN_MS hitting the server simultaneously

  MAX_USERS = 10
  SERVICE_TIME_IN_MS = 500

  def timer_until(task)
    timer_base = self.expires_at - Time.zone.now
    max_fuzz_seconds = 60 * task.condition.primary_activity_schema.starts_every
    fuzz = Integer(
      self.tasks.size / MAX_USERS / (1000 / SERVICE_TIME_IN_MS))
    timer_base + [fuzz, 60 * task.condition.primary_activity_schema.starts_every].min
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
    group_name = Task.chat_group_name_from_tasks(task_list)
    task_list.each { |t| t.assign_to_chat_group(group_name, true) }
  end

end
