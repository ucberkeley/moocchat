module HasManyInline
  require 'active_support/inflector'
  
  # = HasManyInline aggregation
  
  # Allows an "inline has-many" behavior of the following form for ActiveRecord
  # models:
  #
  #   class Foo < ActiveRecord::Base
  #     include HasManyInline
  #     has_many_inline :bars   # bar is also an ActiveRecord model
  #
  #     foo = Foo.first
  #     foo.bars          # => []
  #     foo.bars = Bar.where(...)   # => [an array of Bar instances]
  #     foo.save          # => serializes the Bars' +id+s to an +Array+
  #
  # You can override the name of the underlying ActiveRecord class of the
  # owned things:
  #
  #   class Foo < ActiveRecord::Base
  #     include HasManyInline
  #     has_many_inline :bars, :class_name 'SpecialBar'
  #     Foo.new.bars  # => array of SpecialBar objects
  #
  # It works by serializing the +id+s of the owned objects to an +Array+,
  # so you must provide either a +string+ or a +text+ database field to
  # store the serialized array.
  #
  # Unlike a true +has_many+ association:
  # - you cannot use +belongs_to+ to traverse it backwards;
  # - you can only associate saved objects (those for which +new_record?+ is false)
  # - if you dereference the owned objects and any of them doesn't exist,
  # you'll get an +ActiveRecord::RecordNotFound+ exception
  # - when you save the owning object, no save of the owned objects happens,
  # so don't use this if you're going to modify the owned objects
  #
  # Like +has_many+:
  # - if the owned object(s) change after you've loaded
  # them, you won't see the change unless you do +foo.reload+
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def has_many_inline(owned, options={})
      # owned: pluralized name of underlying AR subclass of owned items
      owned = owned.to_sym
      # owned_class: AR class name of owned items
      owned_class = (options[:class_name] || owned).to_s.classify.constantize
      # attr_name: how the owner will refer to the collection of owned
      # attributes; if nil, infer from owned class name
      serialize owned, Array
      
      self.class_eval do
        define_method owned do
          (self[owned] ||= []).map { |e| owned_class.find e }
        end
        define_method "#{owned}=" do |val|
          self[owned] = val.map(&:id)
        end
      end
    end
  end
end

