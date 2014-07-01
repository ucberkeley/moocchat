When /^I start activity "(.+)" with condition "(.+)" as "(.+)"/ do |activity, condition, learner_name|
  # @task.condition.update_attribute :name, condition
  # @task.activity_schema.update_attribute :name, activity
  steps %Q{When I post to the URL for learner: "#{learner_name}", activity schema: "#{activity}", condition: "#{condition}"}
  # get the newly created task
  @task = Task.where("learner_id = #{Learner.find_by_name!(learner_name).id} AND activity_schema_id = #{@activity_schema.id} AND condition_id = #{@condition.id}").first
end

Given /^the server assigns me to chat group "(.+)"$/ do |group|
  @task.assign_to_chat_group(group)
end

Given /^the server does not assign me to any chat group$/ do
  @task.assign_to_chat_group(WaitingRoom::CHAT_GROUP_NONE)
end
  
Then /^I should see a timer$/ do
  page.should have_selector('#_timer_')
end

When /^the timer expires$/ do
  # If there is a <form>, it gets submitted; if not, the timer's
  # data-submit attribute is used to GET the next page.
  if (button = page.first(:xpath, "//form/input[@type='submit']"))
    click_button button['id']
  else
    visit page.first(:css, '#_timer_')['data-submit']
  end
end
