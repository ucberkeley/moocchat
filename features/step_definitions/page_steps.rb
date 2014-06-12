When /^I post to the URL for learner:\s*"(.+)",\s*activity schema:\s*"(.+)",\s*condition:\s*"(.+)"$/ do |learner, activity_schema, condition|
  page.driver.post url_for(:controller => 'tasks', :action => 'create',
    :learner_name => learner,
    :activity_schema_id => ActivitySchema.find_by_name!(activity_schema).id,
    :condition_id => Condition.find_by_name!(condition).id)
  page.driver.status_code.should == 302
  # Rack::Test doesn't automatically follow redirects
  visit page.driver.response_headers['Location']
end

Then /^I should get (.+) with "(.+)"\s*(and "(.+)")$/ do |page_name, text, _, more_text|
  steps %Q{
    Then I should be on #{page_name}
    And I should see "#{text}"
}
  if more_text
    steps %Q{And I should see "#{more_text}"}
  end
end
