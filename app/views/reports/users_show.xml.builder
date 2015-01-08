xml.instruct!
xml.events do
  @eventlog.each do |event|
    xml.event do
      xml.created_at event.created_at
      xml.task_id event.task_id
      xml.chat_group event.chat_group
      xml.name event.name
      xml.value event.value
    end
  end
end
