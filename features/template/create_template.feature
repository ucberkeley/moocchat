Feature: Create Template as Administrator

  As an Administrator
  So that I can customize my Task
  I want to create a template

Background:
  Given I am on the templates page
  And I follow "New"

Scenario: Create a template, valid conditions, Administrator
  When I fill in "example_name" for "Name"
  And I fill in "<h1>hello</h1>" for "HTML"
  And I press "Create Template"
  Then I should see "Template"
  And I should see "example_name"
 
Scenario: Create a template, invalid conditions-no name, Administrator
  When I fill in "<h1>hello</h1>" for "HTML"
  And I press "Create Template"
  Then I should see "Name can't be blank"

Scenario: Create a template, blank HTML and no url, Administrator
  When I fill in "example_name" for "Name"
  And I press "Create Template"
  Then I should see "You must provide either a non-file URL or HTML text (not both)"
