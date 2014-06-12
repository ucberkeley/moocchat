class Task < ActiveRecord::Base

  has_one :event_log	
  belongs_to :activity_schema
  belongs_to :learner
  belongs_to :condition

  validates_associated :activity_schema
  validates_associated :learner
  validates_associated :condition

  validates_numericality_of :current_question, :greater_than_or_equal_to => 1

  attr_accessible :condition, :learner, :activity_schema, :completed, :chat_group, :current_question

  class ActivityNotOpenError < RuntimeError ; end
  
  def self.create_from_params(params)
    condition = Condition.find params[:condition_id]
    activity_schema = ActivitySchema.find params[:activity_schema_id]
    learner = Learner.find_or_create_by_name! params[:learner_name]

    raise ActivityNotOpenError unless activity_schema.enabled?
    
    @t = Task.create!(
      :condition => condition,
      :learner => learner,
      :completed => false,
      :chat_group => nil,
      :current_question => 1,
      :activity_schema => activity_schema
      )
  end
end


