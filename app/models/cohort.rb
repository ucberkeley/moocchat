class Cohort < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :learners
  has_and_belongs_to_many :instructors
  has_many :activity_schemas
end
