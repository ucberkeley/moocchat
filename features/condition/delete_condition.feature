Feature: Delete Condition as Administrator

  As an Administrator
  So that I can remove unnessary Conditions
  I want to delete a condition

Background:

  Given a condition "cond1"

Scenario: Delete a condition, valid conditions

  Given I am on the conditions page
  When I follow "Delete"
  Then I should not see "cond1"