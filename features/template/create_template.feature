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
 
 Scenario: Create a template, invalid conditions-both url and html are present, Administrator
  Given I am on the templates page
  When I follow "New"
  And I fill in "example_name" for "Name"
  And I fill in "<h1>hello</h1>" for "Html"
  And I fill in "http://www.google.com" for "Url"
  And I press "Create Template"
  Then I should see "You must provide either a non-file URL or HTML text (not both)"

Scenario: Create a template, invalid conditions-no name, Administrator
  Given I am on the templates page
  When I follow "New"
  And I fill in "http://www.google.com" for "Url"
  And I press "Create Template"
  Then I should see "Name can't be blank"

Scenario: Create a template, invalid url, Administrator
  Given I am on the templates page
  When I follow "New"
  And I fill in "example_name" for "Name"
  And I fill in "www.google.com" for "Url"
  And I press "Create Template"
  Then I should see "Url is invalid"