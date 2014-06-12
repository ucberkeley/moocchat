class EventLog < ActiveRecord::Base
  attr_accessible :task_id, :value
   serialize :value, JSON
end
