class TasksController < ApplicationController

  def create

    begin
      puts "I am on the controller"
      @task = Task.create_from_params(params)
      puts "I have left the model"
      redirect_to task_welcome_path(@task)

    rescue ActiveRecord::RecordNotFound => error

      Rails.logger.error error
      redirect_to(task_error_path, :alert => "The activity you tried to start couldn't be found.")

    rescue Task::ActivityNotOpenError

      redirect_to task_error_path, :alert => "This activity isn't open yet."

    end
  end

  def static
    #this creates an anonomous form to fill in params that will be used in task#create
  end

  def welcome
    @task = Task.find params[:id]
  end

  def error
    
  end
end
