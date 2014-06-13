class TasksController < ApplicationController

  def create

    begin

      @task = Task.create_from_params(params)
      redirect_to task_welcome_path(@task)

    rescue ActiveRecord::RecordNotFound => error

      Rails.logger.error error
      redirect_to(task_error_path, :alert => "The activity you tried to start couldn't be found.")

    rescue Task::ActivityNotOpenError

      redirect_to task_error_path, :alert => "This activity isn't open yet."

    end
  end

  def static
    #should this be created in the view or here?
    @task = Task.new
    if @task.save
      redirect_to "/data", notice: 'Task was successfully created.'
    else
      render action: "new"
    end
  end

  def welcome
    @task = Task.find params[:id]
  end

  def error
    
  end
end
