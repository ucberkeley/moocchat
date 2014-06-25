Feature: create activity schema as Administrator

  As an Administrator
  So that I see the name of my condition
  I want to create an activity schema

  Scenario: Create a condition, valid conditions
  Given I am on the conditions page
  When I follow "New"
  Then I should see "Name"
  When I fill in "rob" for "condition_name"
  And I filled in "3" for "condition_prologue_pages"
  And I fill in "trello" for "condition_body_pages"
  And I fill in "end" for "condition_epilogue_pages"
  And I press "Create Condition"
  Then I should see "rob"
  When I follow "Back"
  When I follow "1"
  Then I should see "rob"