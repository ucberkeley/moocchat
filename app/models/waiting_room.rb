class WaitingRoom < ActiveRecord::Base

  # A +WaitingRoom+ collects arriving learners until the next peer activity
  # is scheduled to begin.  When that time comes, the learners in the
  # waiting room are split up into groups and the waiting room is
  # emptied.

  # There is one waiting room for each
  # <ActivitySchema,Condition> pair.
  belongs_to :condition
  belongs_to :activity_schema
  validates :condition_id, :uniqueness => {:scope => :activity_schema_id}
  validates_associated :condition
  validates_associated :activity_schema
  #
  # In terms of the app architecture, the waiting room actually collects
  # +Task+s, which include the learner, activity schema, and condition.
  #
  has_many :tasks

  # It is an error to try to enqueue (put in a waiting room) the same
  # task more than once. 
  class ::TaskAlreadyWaitingError < RuntimeError ; end

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
  def self.add task
    wr = WaitingRoom.
      find_or_create_by_activity_schema_id_and_condition_id!(
      task.activity_schema_id, task.condition_id)
    if wr.tasks.include? task
      raise TaskAlreadyWaitingError
    else
      wr.tasks << task
    end
  end

end
