class TasksController < ApplicationController

  before_filter :check_if_test_user, :except => [:create, :create_turk, :static]
  skip_before_filter :require_authenticated_user

  protected

  def check_if_test_user
    @task = Task.find params[:id]
    @test_user = @task.learner.for_testing?
  end

  public

  def static
    # creates an anonymous form to fill in params that will be used in task#create
  end

  def create
    self.create_from_params(params.merge(:turk_params => nil))
  end

  def create_turk
    if params[:assignmentId]=='ASSIGNMENT_ID_NOT_AVAILABLE'
      render "turk_preview"
    else
      self.create_from_params({:condition_id => params[:condition_id],
                               :learner_name => 'Turk worker ' + params[:workerId],
                               :turk_params => params})
    end
  end

  def create_from_params(params)
    learner = User.find_by_name(params[:learner_name])
    if learner and not learner.for_testing and Task.where(["chat_group IS NOT NULL AND learner_id=?", learner.id]).present?
      render "already_completed_task"
      return
    end

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

  #
  #  All methods below this point rely on the before_filter to set up @task
  #
  def welcome
    # Consider initial welcome page request to also be a heartbeat
    # This deals with an edge case where someone arrives at the last moment and
    # transitions to the next page before they can send a heartbeat message.
    @task.last_heartbeat = Time.zone.now

    unless (@timer = session[:timer])
      redirect_to :action => 'sorry', :notice => 'Timer value was not found.'
    end
    @heartbeat_seconds = WaitingRoom.heartbeat_seconds
    # never start with a timer of zero. If timer is zero, bump up to
    # next start time.
    if @timer.zero? then @timer += @task.condition.primary_activity_schema.starts_every end
  end

  def force_continue
    if @test_user
      @task.force_group_formation_now!
      session[:timer] = 0
    end
    redirect_to task_welcome_path(@task)
  end

  def join_group
    @task.last_heartbeat = Time.zone.now # Consider join_group request to also be a heartbeat
    @task.save!
    
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
      current_time = Time.now
      @task.update_attribute(:start_page_time, current_time)    #set the time the learner started the activity
      @task.log :form_group
      @task.save!
      redirect_to task_page_path(@task)
    end
  end
  
  def page
    @task_id = params[:id]
    @template = @task.current_page
    if @task.start_page_time
      @offset = (Time.now - @task.start_page_time).to_i
    else
      @offset = 0
    end

    if @template.nil?
      redirect_to('/', :notice => 'No more pages left in task')
    end
    # set up variables for template to consume
    @question = @task.current_question
    @question_counter = @task.question_counter
    @counter = @task.counter
    @subcounter = @task.subcounter
    @chat_group = @task.chat_group
    @start_form_tag = view_context.form_tag(task_next_page_path(@task),
      'id' => '_main', 'data-log-url' => task_collect_response_path(@task))
    @submit_to = task_next_page_path @task
    @me = @task.learner_index
    @data = @task.user_state_for_all
    @turk_params = @task.turk_params
    @u = @data[@me] || {}
    # HTML text that will be injected into generic uber-template
    @html = @template.html
    @task.log :view_page
    render :inline => @html, :layout => false
  end

  # user clicks submit => AJAX form submission posts to collect_response,
  # which records and timestamps answer WITHOUT advancing task counters

  def collect_response
    render(:nothing => true, :status => 403) and return unless request.xhr?
    # save any user state posted by template; if none provided, don't overwrite
    if params[:u]
      user_state = params[:u].stringify_keys
      @task.update_attribute(:user_state, user_state)
      user_state.each_pair do |key,val|
        @task.log(:user_state, "#{key}=#{val}")
      end
    end
    render :nothing => true
  end

  # timeout => directly post the form to next_page, which ONLY
  # advances the counters

  def next_page
    @task.next_page!
    # if 'next_question' field is nonblank, advance question counter
    @task.next_question! if !params[:next_question].blank?
    if @task.current_page
      current_time = Time.now
      @task.update_attribute(:start_page_time, current_time)    #set the time the learner started the activity
      # log the event of user 'continuing'
      @task.log(:continue)
      redirect_to task_page_path(@task)
    else
      @task.log :finish
      redirect_to '/'
    end
  end

  def log
    render(:nothing => true, :status => 403) and return unless request.xhr?
    # Log the event
    @task.log params[:name], params[:value]
    render :nothing => true
  end

  def error

  end

  def disconnect
    render(:nothing => true, :status => 403) and return unless request.xhr?
    task_id = params[:id].to_i
    @task.group_tasks.each { |t| Task.find(t).remove_from_chat_group task_id }
    render :nothing => true
  end

  def heartbeat
    render(:nothing => true, :status => 403) and return unless request.xhr?
    @task.last_heartbeat = Time.zone.now
    @task.save!
    render :nothing => true
  end
end
