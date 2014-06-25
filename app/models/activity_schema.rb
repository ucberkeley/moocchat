class ActivitySchema < ActiveRecord::Base
  include HasManyInline
  has_many :tasks
  belongs_to :cohort
  attr_accessible :cohort_id


  # Minimum interval between experiment starts, in minutes
  MINIMUM_INTERVAL_BETWEEN_EXPERIMENTS = 5

  # Human friendly name for the activity schema.
  attr_accessible :name
  validates_presence_of :name

  attr_accessible :cohort,:randomized,:num_questions,:tag

  attr_accessible :questions
  has_many_inline :questions

  # Boolean attribute: whether this activity is enabled (open for business)
  # TBD: Is this obsoleted by having the start and end times?
  attr_accessible :enabled

  # Earliest time someone can try to start the activity.  Must align on an activity boundary,
  # e.g. if the activity begins every 12 minutes, start time must be at :00, :12, :24, etc.
  attr_accessible :start_time
  validates :start_time, :date => true
  validate :start_time, :must_align_on_activity_boundary

  # Latest time someone can try to start the activity
  attr_accessible :end_time
  validates(:end_time,
    :date => {
      :after => lambda { |activity| activity.start_time },
      :message => 'must be later than start time'
    })

  # How often in minutes the activity restarts.  Must be greater than the minimum interval between
  # experiments, and must divide evenly into 60 minutes.
  attr_accessible :starts_every
  validates_numericality_of(:starts_every,
    :only_integer => true,
    :greater_than_or_equal_to => MINIMUM_INTERVAL_BETWEEN_EXPERIMENTS)
  validate :starts_every_must_divide_into_60

  private
  
  def starts_every_must_divide_into_60
    return if starts_every.to_i.zero? # another validation will catch this.
    errors.add(:starts_every, 'must divide evenly into 60') unless (60 % starts_every.to_i == 0)
  end

  def must_align_on_activity_boundary
    return if starts_every.to_i.zero? || start_time.nil? # other validations will catch these
    errors.add(:start_time,
      "must align with an activity boundary (:00, :#{'%02d' % starts_every}, :#{'%02d' % (2*starts_every)}, etc.)") unless start_time.min % starts_every.to_i == 0
  end

  public

end