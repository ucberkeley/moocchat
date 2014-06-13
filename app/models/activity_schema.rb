class ActivitySchema < ActiveRecord::Base
  has_many :tasks
  belongs_to :cohort
  serialize :questions, Array

  validates_presence_of :name
  attr_accessible :name

end
