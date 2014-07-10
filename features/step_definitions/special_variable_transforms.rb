# any occurrence of "<my chat group>" in a step or table will be converted
# to the actual value of the chat group name, which isn't known til runtime
# since it's based on the task ID.

Transform /^<my chat group>$/ do |_|
  @task.chat_group
end

Transform /^table:name,chat_group,counter$/ do |table|
  table.map_column 'chat_group' do |value|
    value =~ /<my chat group>/ ? @task.chat_group : value
  end
end
