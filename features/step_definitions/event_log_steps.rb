Then /^the following log entries should exist for that task in this order:$/ do |table|
  attribs = table.column_names
  # make sure each successive specified row exists, matches exactly once
  # in database, and has created_at greater than the previous match.
  last_timestamp = 1.year.ago   # "infinity ago"
  table.hashes.each do |record|
    values = record.delete_if { |k,v| v.blank? } # ignore blank fields
    result = EventLog.where(values)
    result.should have(1).event_log, "Event with #{values} not found"
    timestamp = result.first.created_at
    timestamp.should be >= last_timestamp
    last_timestamp = timestamp
  end
end
