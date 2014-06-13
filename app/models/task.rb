class Task < ActiveRecord::Base

  require_relative './task/task_sequencer'

  belongs_to :activity_schema
  belongs_to :learner
  belongs_to :condition

  validates_associated :activity_schema
  validates_associated :learner
  validates_associated :condition

  attr_accessible :condition, :learner, :activity_schema, :completed, :chat_group, :sequence_state


  class ActivityNotOpenError < RuntimeError ; end

  serialize :sequence_state, Sequencer

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
      :activity_schema => activity_schema,
      :sequence_state => Sequencer.new(activity_schema.num_questions)
      )
  end

end
