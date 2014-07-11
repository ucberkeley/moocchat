class TasksController < ApplicationController

  def static
    # creates an anonymous form to fill in params that will be used in task#create
  end

  def create
    begin
      @task = Task.create_from_params(params)
      @timer = session[:timer] = WaitingRoom.add(@task)
      @task.log(:start)
      redirect_to task_welcome_path(@task)
    rescue ActiveRecord::RecordNotFound => error
      Rails.logger.error error
      redirect_to(task_error_path, :alert => "The activity you tried to start couldn't be found.")
    rescue Task::ActivityNotOpenError
      redirect_to task_error_path, :alert => "This activity isn't open yet."
    end
  end

  def welcome
    unless (@timer = session[:timer])
      redirect_to :action => 'sorry', :notice => 'Timer value was not found.'
    end
    @task = Task.find params[:id]
  end

  def join_group
    @task = Task.find params[:id]
    WaitingRoom.process_all!
    case @task.chat_group
    when WaitingRoom::CHAT_GROUP_NONE
      @task.log :reject
      render :action => 'sorry'
    when nil
      # WaitingRoom didn't get emptied.  Wait a few seconds and try again.
      # :BUG: this should be logged
      session[:timer] = 5
      render :action => 'welcome'
    else
      @task.log :form_group
      @task.save!
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
    @answers = @question.answers
    @question_counter = @task.question_counter
    @counter = @task.counter
    @subcounter = @task.subcounter
    @chat_group = @task.chat_group
    @start_form_tag = view_context.content_tag :form, 'action' => task_next_page_path(@task), 'data-log-url' => task_log_event_path(@task)
    @submit_to = task_next_page_path @task
    @me = @task.learner_index
    @data = @task.user_state_for_all
    @u = @data[@me] || {}
    # HTML text that will be injected into generic uber-template
    @html = @template.html
    @task.log :view_page
    render :inline => @html, :layout => false
  end

  def next_page
    @task = Task.find params[:id]
    # save any user state posted by template; if none provided, don't overwrite
    @task.update_attribute(:user_state, params[:u].stringify_keys) if params[:u]
    @task.next_page!
    # if 'next_question' field is nonblank, advance question counter
    @task.next_question! if !params[:next_question].blank?
    if @task.current_page
      redirect_to task_page_path(@task)
    else
      @task.log :finish
      redirect_to '/'
    end
  end

  def log
    render(:nothing => true, :status => 403) and return unless request.xhr?
    render :nothing => true
  end

  def error
    
  end
end
