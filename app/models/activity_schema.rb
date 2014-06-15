class ActivitySchema < ActiveRecord::Base
  include HasManyInline
  has_many :tasks
  belongs_to :cohort

  validates_presence_of :name
  attr_accessible :name, :enabled, :cohort, :questions, :randomized, :num_questions, :tag

  has_many_inline :questions, :class_name => :question

end
