Feature: Create Template as Administrator

  As an Administrator
  So that I can customize my Task
  I want to create a template

Scenario: Create a template, valid conditions, Administrator
  Given I am on the templates page
  When I follow "New"
  And I fill in "example_name" for "Name"
  And I fill in "<h1>hello</h1>" for "Html"
  And I press "Create Template"
  Then I should see "Template"
  And I should see "example_name"
 