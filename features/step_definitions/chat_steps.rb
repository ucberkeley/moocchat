# Steps for single-user waiting room leading to a chat page

Given /^I am a learner assigned to a singleton waiting room$/ do
  @task = create :task, :with_chat_group
  @task.assign_to_chat_group Task.chat_group_name_from_tasks([@task])
  @task.save!
end

When /^I have advanced to a chat page$/ do
  # arrange for @task.current_page (called in TasksController to determine
  # what to display)
  @page = create :template_with_chat
  Task.stub(:find).and_return(@task)
  @task.stub(:current_page).and_return(@page)
  visit task_page_path(@task)
end

When ^I send "(.*)" as my chat text$/ do |string|
  fill_in 'chat-box', :with => string
  
end
