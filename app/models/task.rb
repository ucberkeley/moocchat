class Task < ActiveRecord::Base
  has_many :activity_schemas
  belongs_to :learner
  belongs_to :condition
end
