class Condition < ActiveRecord::Base
  include HasManyInline
  has_many :tasks

  has_many_inline :prologue_pages, :class_name => :template
  has_many_inline :body_pages, :class_name => :template
  has_many_inline :epilogue_pages, :class_name => :template

end
