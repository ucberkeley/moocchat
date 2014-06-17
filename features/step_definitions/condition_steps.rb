Given /^a condition "(.*?)"$/ do |name|
  create :condition, :name => name
end

Given /^a task with a (\d+)-page condition repeated (\d+)\s+times?/ do |num_steps,repeat|
  templates = Array.new(num_steps) { create :template }
  condition = create :condition, :body => [template_id]
  @task = create :task, :condition => condition, :activity_schema =>
    create :activity_schema(:num_questions => repeat)
end
