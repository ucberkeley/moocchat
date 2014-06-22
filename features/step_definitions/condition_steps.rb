Given /^a condition "(.*?)"$/ do |name|
  @c1 = create :condition, :name => name
end

Given(/^I start on the Edit Page for condition$/) do 
	visit edit_condition_path(@c1)
end