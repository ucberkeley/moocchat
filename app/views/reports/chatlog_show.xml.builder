xml.instruct!
xml.events do
  @eventlog_sessions.each do |session|
    session.each do |event|
      xml.event do
        xml.session_chat_group event.task.original_chat_group
        xml.created_at event.created_at
        xml.task_id event.task_id
        xml.chat_group event.chat_group
        xml.name event.name
        xml.value event.value
      end
    end
  end
end
