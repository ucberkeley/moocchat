Given /^an activity schema "(.*?)"$/ do |name|
  @activity_schema = ActivitySchema.create! :name => name
end
