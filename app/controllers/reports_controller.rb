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
      format.xml  # 'chatlog_show.xml.builder'
      format.csv  # 'chatlog_show.csv.csvbuilder'
      format.xlsx # 'chatlog_show.xlsx.axlsx'
    end
  end

  def sessions
  end

  def sessions_show
    eventlog_sessions = eventlog_sessions(EventLog.where(created_at: parse_datetime_picker_date(params[:datetime_start])..parse_datetime_picker_date(params[:datetime_end])))

    @sessions = []
    eventlog_sessions.each do |session_events|
      orig_chat_group_str = session_events.first.task.original_chat_group
      orig_chat_group = Task.parse_group_tasks(orig_chat_group_str)
      question = session_events.first.question
      session = {chat_group: orig_chat_group_str, group_size: orig_chat_group.length,
        question_id: question ? question.id : '', correct_choice: question ? ("A".."Z").to_a[question.correct_answer_index] : '',
        start_time_0: '', start_time_1: '', start_time_2: '',
        initial_choice_0: '', initial_choice_1: '', initial_choice_2: '',
        final_choice_0: '', final_choice_1: '', final_choice_2: '',
      }
      session_events.each do |event|
        learner_index = orig_chat_group.index(event.task_id)
        if event.name == 'start' then
          session[('start_time_%s' % learner_index).to_sym] = event.created_at
        elsif event.name == 'user_state' and (match = /^choice=(.*)$/.match(event.value)) then
          session[('initial_choice_%s' % learner_index).to_sym] = match[1]
        elsif event.name == 'user_state' and (match = /^final_choice=(.*)$/.match(event.value)) then
          session[('final_choice_%s' % learner_index).to_sym] = match[1]
        end
      end
      @sessions.push(session)
    end

    respond_to do |format|
      format.html # 'sessions_show.html.erb'
      format.xml  # 'sessions_show.xml.builder'
      format.csv  # 'sessions_show.csv.csvbuilder'
      format.xlsx # 'sessions_show.xlsx.axlsx'
    end
  end
end
