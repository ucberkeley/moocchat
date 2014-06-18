Given /^a task with a (\d+)-page condition repeated (\d+)\s+times?/ do |num_steps,repeat|
  templates = Array.new(num_steps.to_i) { create :template }
  condition = create :condition, :body_pages => templates
  activity = create(:activity_schema, :num_questions => repeat.to_i)
  @task = create :task, :condition => condition, :activity_schema => activity
end

When /^I visit the (first|next) page of that task$/ do |_|
  # references to 'that task' refer to instance variable @task, which
  # should be set by some previous step
  @task.should be_a_kind_of Task
  visit task_page_path(@task)
end
