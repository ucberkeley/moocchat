class Question < ActiveRecord::Base
  serialize :answers, Array
end
