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

  # When the class method +process_all!+ is called, all waiting rooms
  # are checked to see if any of them have an expired timer, and
  # +WaitingRoom#process!+ is called on any ready instances.  The call
  # to +process_all!+ can be triggered by a cron job or by connecting
  # the method to an authenticated endpoint.
  #


end
