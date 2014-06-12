class TasksController < ApplicationController

  def create

    begin

      @task = Task.create_from_params(params)
      redirect_to :action => :welcome, :id => @task

    rescue ActiveRecord::RecordNotFound => @error

      Rails.logger.error @error
      render 'application/error'

    end
  end

  def welcome
  end
end
