class Condition < ActiveRecord::Base
  include HasManyInline
  has_many :tasks

  attr_accessible :name, :prologue_pages, :body_pages, :epilogue_pages

  has_many_inline :prologue_pages, :class_name => :template
  has_many_inline :body_pages, :class_name => :template
  has_many_inline :epilogue_pages, :class_name => :template

end
