module HasManyInline
  require 'active_support/inflector'
  extend ActiveSupport::Concern
  
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
    def base.has_many_inline(owned)
      owned_class = owned.to_s.classify.constantize
      # alias original attribute getter, and shadow it
      self.send :serialize, :owned, Array
      self.alias_method owned, "_orig_#{owned}"
      self.define_method owned do
        self.send("_orig_#{owned}").map do |item|
          owned_class.send(:find, item.to_s).freeze
        end
      end
      self.send :before_save, "serialize_#{owned}"
      self.define_method "serialize_#{owned}" do
        
      end
    end
  end

end
