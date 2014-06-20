class ActivitySchema < ActiveRecord::Base
  include HasManyInline
  has_many :tasks
  belongs_to :cohort

  # Minimum interval between experiment starts, in minutes
  MINIMUM_INTERVAL_BETWEEN_EXPERIMENTS = 5

  # Human friendly name for the activity schema.

  attr_accessible :name, :cohort,:randomized,:num_questions,:tag,:questions
  validates_presence_of :name

  has_many_inline :questions, :class_name => :question

  # Boolean attribute: whether this activity is enabled (open for business)
  # TBD: Is this obsoleted by having the start and end times?
  attr_accessible :enabled

  # Earliest time someone can try to start the activity
  attr_accessible :start_time
  validates :start_time, :date => true

  # Latest time someone can try to start the activity
  attr_accessible :end_time
  validates :end_time, :date => { :after => lambda { |activity| activity.start_time }}

  # How often in minutes the activity restarts
  attr_accessible :starts_every
  validates_numericality_of :starts_every, :greater_than_or_equal_to => MINIMUM_INTERVAL_BETWEEN_EXPERIMENTS

end
