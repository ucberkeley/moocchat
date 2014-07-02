class TasksController < ApplicationController

  def static
    # creates an anonymous form to fill in params that will be used in task#create
  end

  def create
    begin
      @task = Task.create_from_params(params)
      @timer = WaitingRoom.add @task
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

  def join_group
    @task = Task.find params[:id]
    WaitingRoom.process_all!
    if @task.chat_group == WaitingRoom::CHAT_GROUP_NONE
      render :action => 'sorry'
      @task.destroy
    else
      redirect_to task_page_path(@task)
    end
  end
  
  def page
    @task_id = params[:id]
    @task = Task.find @task_id
    @template = @task.current_page
    if @template.nil?
      redirect_to('/', :notice => 'No more pages left in task')
    end
    # set up variables for template to consume
    @question = @task.current_question
    @counter = @task.counter
    @submit_to = task_next_page_path @task
    @chat_group = @task.chat_group
    @u = @task.user_state || {}
    # HTML text that will be injected into generic uber-template
    @html = @template.html
    render :inline => @html, :layout => false
  end

  def next_page
    @task = Task.find params[:id]
    # save any user state posted by template; if none provided, don't overwrite
    @task.update_attribute(:user_state, params[:u].stringify_keys) if params[:u]
    @task.next_page!
    if @task.current_page
      redirect_to task_page_path(@task)
    else
      redirect_to '/'
    end
  end

  def error
    
  end
end
