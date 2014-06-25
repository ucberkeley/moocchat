Feature: create template as Administrator

  As an Administrator
  So that I see the name of my template
  I want to create a template

  Scenario: Create a template, valid conditions
  Given I am on the templates page
  When I follow "New"
  Then I should see "Name"
  When I fill in "example_name" for "template_name"
  And I fill in "<h1>hello</h1>" for "template_html"
  And I press "Create Template"
  Then I should see "example_name"
  When I follow "Back"
  When I follow "1"
  Then I should see "example"