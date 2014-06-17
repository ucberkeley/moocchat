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
    id, template_id = params.values_at[:id, :page_id]
    @task = Task.find(id)
    template = @task.current_page
    # set up variables for template to consume
    @question = @task.current_question
    @page_id = "#{id} / #{@task.sequence_state.counter}"
    render :html => template.safe_html
  end

  def error
    
  end
end
