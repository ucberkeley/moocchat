class ReportsController < ApplicationController
  def chatlog
  end

  def eventlog_sessions(eventlog)
    result = []
    eventlog_ordered = eventlog.joins(:task).order('tasks.original_chat_group', :created_at)
    current_session = []
    prev_orig_chat_group = nil
    eventlog_ordered.each do |event|
      orig_chat_group = event.task.original_chat_group
      if Task.where(original_chat_group: orig_chat_group).any? {|t| t.learner and t.learner.for_testing } then next end
      if prev_orig_chat_group and prev_orig_chat_group != orig_chat_group then
        result.push(current_session)
        current_session = []
      end
      current_session.push(event)
      prev_orig_chat_group = orig_chat_group
    end
    result
  end

  def parse_datetime_picker_date(d)
    return DateTime.strptime(d, '%m/%d/%Y %l:%M %p')
  end

  def chatlog_show
    @eventlog_sessions = eventlog_sessions(EventLog.where(created_at: parse_datetime_picker_date(params[:datetime_start])..parse_datetime_picker_date(params[:datetime_end])))

    respond_to do |format|
      format.html # 'chatlog_show.html.erb'
      format.json { render json: @eventlog_sessions }
    end
  end

  def users_show
    @eventlog = EventLog.all

    respond_to do |format|
      format.xml  # 'users_show.xml.builder'
    end
  end
end
