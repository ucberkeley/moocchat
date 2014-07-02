class Condition < ActiveRecord::Base
  include HasManyInline
  has_many :tasks
  has_many_inline :prologue_pages, :class_name => :template
  has_many_inline :body_pages, :class_name => :template
  has_many_inline :epilogue_pages, :class_name => :template

  # The maximum allowable group size; experiments cannot specify chat groups
  # containing more than this number of learners.
  MAX_ALLOWABLE_GROUP_SIZE = 20

  # Human-friendly name for the condition or experiment; must be unique
  attr_accessible :name, :prologue_pages, :body_pages, :epilogue_pages,:preferred_group_size, :minimum_group_size
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :preferred_group_size,
  :greater_than_or_equal_to => 1,
  :less_than_or_equal_to => MAX_ALLOWABLE_GROUP_SIZE
  validates_numericality_of :minimum_group_size,
  :greater_than_or_equal_to => 1,
  :less_than_or_equal_to => ->(condition) { condition.preferred_group_size },
  :message => 'must be between 1 and preferred group size'
  
  validate :at_least_one_page?

  def at_least_one_page?
    a1=self.prologue_pages.size
    a2=self.body_pages.size
    a3=self.epilogue_pages.size
    if !(a1 + a2 + a3 >0)
      errors.add(:condition,'must at least contain a prologue_page,a body_page, or an epilogue_page') 
    end
  end

end