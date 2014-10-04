Given /^a condition "(.*?)"$/ do |name|
  @condition = create(:condition, :name => name, :body_repeat_count => 1,:prologue_pages => [create(:template)])
end

Given /^a condition "(.*)" with group size (\d+)\.+(\d+)$/ do |name,min,max|
  @condition = create :condition, :preferred_group_size => max, :minimum_group_size => min, :name => name
end

Given(/^I start on the Edit Page for condition$/) do 
	visit edit_condition_path(@condition)
end

Then(/^I should redirect to the show page for condition$/) do 
	current_path.should == condition_path(@condition)
end

When /^I start test driving condition "(.*)" with group size (\d+)$/ do |name,size|
  @test_learner = Learner.where(:for_testing => true).first
  @activity_schema = ActivitySchema.first
  steps %Q{
    Given a condition "#{name}" with group size #{size}..#{size}
    And I am on the conditions page
    When I press "Test Drive" within the table row containing "#{name}"
  }
end
