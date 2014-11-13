Feature: Delete Condition as Administrator

  As an Administrator
  So that I can remove unnessary Conditions
  I want to delete a condition

Background:

  Given a condition "Default"

@wip
Scenario: Delete a condition, valid conditions

  Given I am on the conditions page
  When I follow "Delete" within the table row containing "Default"
  Then I should be on the conditions page
  Then I should not see "Default"
