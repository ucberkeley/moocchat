class Question < ActiveRecord::Base
  serialize :answers, Array
  attr_accessible  :answers, :text,:correct_answer_index, :explanation
end
