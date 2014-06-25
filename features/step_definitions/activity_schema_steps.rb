Given /^an activity schema "(.*?)"$/ do |name|
  @activity_schema1 = create(:activity_schema, :name => name, :start_time => Time.zone.now.midnight, :end_time => Time.zone.now.midnight + 2.days)
end
Given(/^I start on the Edit Page for activity_schema$/) do 
	visit edit_activity_schema_path(@activity_schema1)
end