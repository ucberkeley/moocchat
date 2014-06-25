Feature: Create Condition as Administrator

  As an Administrator
  So that I set my Condtions
  I want to create a condition

Background:
  Given I am on the conditions page
  And I follow "New"

Scenario: Create a condition, valid conditions,Administrator
  When I fill in "rob" for "condition_name"
  And I filled in "3" for "condition_prologue_pages"
  And I fill in "trello" for "condition_body_pages"
  And I fill in "end" for "condition_epilogue_pages"
  And I press "Create Condition"
  Then I should see "rob"
 