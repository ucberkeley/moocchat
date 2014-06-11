class ActivitySchema < ActiveRecord::Base
  belongs_to :task
  belongs_to :cohort
  serialize :questions, Array
end
