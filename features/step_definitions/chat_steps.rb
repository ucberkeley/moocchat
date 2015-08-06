# Steps for single-user waiting room leading to a chat page

Given /^I am a learner assigned to a singleton waiting room$/ do
  @task = create :task, :with_chat_group
  @task.assign_to_chat_group(Task.chat_group_name_from_tasks([@task]), true)
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


When /^I send "(.*)" as my chat text$/ do |string|
  fill_in 'input-text', :with => string
  click_button 'send-chat-message'
end

And /^I wait for (\d+) seconds$/ do |n|
  #sleep(n.to_i)
end

Then /^the chat box should contain "(.*)"$/ do |string|
  expect(page).to have_selector("#chat-system")
  expect(page).to have_selector("#input-text", text: '')
  page.should have_css(".moocchat-message")
end

Then /^the chat box should contain2 \/([^\/]*)\/$/ do |re|
  regexp = Regexp.new re
  within '#chat-system' do
    page.should have_xpath('//*', :text => regexp)
  end
end
