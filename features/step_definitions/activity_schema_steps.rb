Given /^an activity schema "(.*?)"$/ do |name|
  @activity_schema = create(:activity_schema, :name => name)
end
