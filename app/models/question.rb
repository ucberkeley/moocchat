class Question < ActiveRecord::Base
  has_many :event_logs
  serialize :answers, Array
  attr_accessible  :answers, :text,:correct_answer_index, :explanation
end
