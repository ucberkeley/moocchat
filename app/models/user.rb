class User < ActiveRecord::Base
  attr_accessible :name, :email
  validates_uniqueness_of :email, :allow_nil => true
  validates :email, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }, :allow_nil => true
  def authorized?
    self.class == Administrator || self.class == Instructor
  end
  def self.authorized?(id)
    User.find_by_id(id).try(:authorized?)
  end
end
