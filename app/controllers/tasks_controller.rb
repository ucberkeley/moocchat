class TasksController < ApplicationController

  def create

    begin

      @task = Task.create_from_params(params.values_at(:learner, :activity_schema_id, :condition_id))
      redirect_to :action => :welcome, :id => @task

    rescue ActiveRecord::RecordNotFound => @error

      Rails.logger.error @error
      render 'application/error'

    end
  end

  def welcome
  end
end
