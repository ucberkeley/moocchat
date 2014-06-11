class Response < ActiveRecord::Base
  belongs_to :task
  serialize :value, JSON
end
