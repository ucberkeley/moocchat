Given /^a condition "(.*?)"$/ do |arg|
  @c1 = Condition.create!(name: arg, preferred_group_size: 3, minimum_group_size: 1)
end

Given(/^I start on the Edit Page for condition$/) do 
	visit edit_condition_path(@c1)
end