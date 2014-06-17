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

  def welcome
    @task = Task.find params[:id]
  end

  def page
    @task_id = params[:id]
    @task = Task.find @task_id
    template = @task.current_page
    # set up variables for template to consume
    @question = @task.current_question
    @template_id = template.id
    @counter = @task.counter
    # HTML text that will be injected into generic uber-template
    @html = template.html
    render :inline => @html, :layout => false
  end

  def next_page
    @task = Task.find params[:id]
    @task.next_page!
    if @task.current_page
      redirect_to task_page_path(@task)
    else
      redirect_to :root
    end
  end

  def error
    
  end
end
