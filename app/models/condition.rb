class Condition < ActiveRecord::Base
  include HasManyInline
  has_many :tasks

  # The maximum allowable group size; experiments cannot specify chat groups
  # containing more than this number of learners.
  MAX_ALLOWABLE_GROUP_SIZE = 20

  # Human-friendly name for the condition or experiment; must be unique
  attr_accessible :name
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many_inline :prologue_pages, :class_name => :template
  has_many_inline :body_pages, :class_name => :template
  has_many_inline :epilogue_pages, :class_name => :template

  attr_accessible :preferred_group_size, :minimum_group_size
  validates_numericality_of :preferred_group_size,
  :greater_than_or_equal_to => 1,
  :less_than_or_equal_to => MAX_ALLOWABLE_GROUP_SIZE
  validates_numericality_of :minimum_group_size, :greater_than_or_equal_to => 1,
  :less_than_or_equal_to => ->(condition) { condition.preferred_group_size },
  :message => 'must be between 1 and preferred group size'
  
end
