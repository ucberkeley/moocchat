def expire_timer_and_continue
  # If there is a <form>, it gets submitted; if not, the timer's
  # data-submit attribute is used to GET the next page.
  if (button = page.first(:xpath, "//form/input[@type='submit']"))
    click_button button['id']
  else
    visit page.first(:css, '#_timer_')['data-submit']
  end
end

When /^I start activity "(.+)" with condition "(.+)" as "(.+)"/ do |activity, condition, learner_name|
  steps %Q{When I post to the URL for learner: "#{learner_name}", activity schema: "#{activity}", condition: "#{condition}"}
  # get the newly created task
  @task = Task.where("learner_id = #{Learner.find_by_name!(learner_name).id} AND activity_schema_id = #{@activity_schema.id} AND condition_id = #{@condition.id}").first
end

#  The step defs that handle assigning a learner to a chat group (or not)
#  work by temporarily stubbing WaitingRoom.process_all!, which processes
#  the waiting room to perform these assignments.

When /^the timer expires and the server assigns me to (no )?chat group( "(.+)")?$/ do |none,_,group|
  WaitingRoom.stub(:process_all!)
  @task.assign_to_chat_group(none ? WaitingRoom::CHAT_GROUP_NONE : group)
  expire_timer_and_continue
end

Then /^I should see a timer$/ do
  page.should have_selector('#_timer_')
end

When /^the timer expires$/ do
  expire_timer_and_continue
end
