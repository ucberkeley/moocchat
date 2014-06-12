class Learner < User
  has_many :tasks
  has_and_belongs_to_many :cohorts

  validates_presence_of :name
  validates_uniqueness_of :name

end
