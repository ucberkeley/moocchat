Given /^a condition "(.*?)"$/ do |name|
  @condition = create(:condition, :name => name, :prologue_pages => [create(:template)])
end

Given(/^I start on the Edit Page for condition$/) do 
	visit edit_condition_path(@condition)
end

Then(/^I should redirect to the show page for condition$/) do 
	current_path.should == condition_path(@condition)
end