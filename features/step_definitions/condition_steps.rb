Given /^a condition "(.*?)"$/ do |name|
  @condition = create(:condition, :name => name, :body_repeat_count => 1,:prologue_pages => [create(:template)])
end

Given(/^I start on the Edit Page for condition$/) do 
	visit edit_condition_path(@condition)
end

Then(/^I should redirect to the show page for condition$/) do 
	current_path.should == condition_path(@condition)
end

Given /^a condition "(.*)" with group size (\d+)\.+(\d+)$/ do |name,min,max|
  @condition = create :condition, :preferred_group_size => max, :minimum_group_size => min, :name => name
end

When /^I test drive condition "(.*)"$/ do |name|
  @condition = Condition.find_by_name(name)
  @test_learner = Learner.where(:for_testing => true).first
  @activity_schema = ActivitySchema.first
  
end
