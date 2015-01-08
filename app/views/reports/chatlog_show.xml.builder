xml.instruct!
xml.events do
  session_num = 0
  @eventlog_sessions.each do |session|
    session_num += 1
    session.each do |event|
      xml.event do
        xml.session_num session_num
        xml.created_at event.created_at
        xml.task_id event.task_id
        xml.chat_group event.chat_group
        xml.name event.name
        xml.value event.value
      end
    end
  end
end
