Given /^an activity schema "(.*?)"$/ do |name|
  @activity_schema1 = create(:activity_schema, :name => name, :start_time => Time.zone.now.midnight, :end_time => Time.zone.now.midnight + 2.days)
end

Given(/^I start on the Edit Page for activity_schema$/) do 
	visit edit_activity_schema_path(@activity_schema1)
end

Given /^an enabled activity "(.+)" that starts every (\d+) minutes$/ do |name,every|
  @activity_schema = create(:activity_schema, :name => name,
    :start_time => Time.now.change(:min => 0),
    :end_time => 1.day.from_now,
    :starts_every => every,
    :enabled => true)
end
