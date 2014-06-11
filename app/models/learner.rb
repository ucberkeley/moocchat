class Learner < User
  has_many :tasks
  has_and_belongs_to_many :cohorts
end
