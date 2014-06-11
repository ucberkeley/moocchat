class Instructor < User
  has_and_belongs_to_many :cohorts
end
