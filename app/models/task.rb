class Task < ActiveRecord::Base
  has_one :event_log	
  has_many :activity_schemas
  belongs_to :learner
  belongs_to :condition
end
