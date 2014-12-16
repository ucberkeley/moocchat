Given(/^I start on the Static Page$/) do 
	visit root_path
end

When /^I post to the URL for learner:\s*"(.+)",\s*condition:\s*"(.+)"$/ do |learner, condition|
  condition_id = Condition.find_by_name!(condition).id
  page.driver.post url_for(:controller => 'tasks', :action => 'create',
    :learner_name => learner,
    :condition_id => condition_id)
  page.driver.status_code.should == 302
  # Rack::Test doesn't automatically follow redirects
  visit page.driver.response_headers['Location']

  @task = Task.find_by_learner_id_and_condition_id!(
    Learner.find_by_name!(learner).id, condition_id)
end

Given /^a task with a (\d+)-page condition repeated (\d+)\s+times?/ do |num_steps,repeat|
  templates = Array.new(num_steps.to_i) { create :template }
  activity = create :activity_schema, :name => 'a1', :num_questions => repeat.to_i
  condition = create :condition, :name => 'c1', :body_pages => templates, :primary_activity_schema => activity
  steps %Q{When I post to the URL for learner: "armando", condition: "c1"}
  @task.update_attribute :chat_group, Task.chat_group_name_from_tasks([@task])
end

When /^I visit the (first|next) page of that task$/ do |_|
  # references to 'that task' refer to instance variable @task, which
  # should be set by some previous step
  @task.should be_a_kind_of Task
  visit task_page_path(@task)
end
