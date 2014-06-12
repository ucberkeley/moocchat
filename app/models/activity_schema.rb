class ActivitySchema < ActiveRecord::Base
  has_many :tasks
  belongs_to :cohort
  serialize :questions, Array
end
