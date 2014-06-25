Feature: Update Condition as Administrator

  As an Administrator
  So that I configure my specific condition
  I want to be able to edit a condition

Background:

  Given a condition "cond1"

Scenario: edit page, valid conditions, Administrator

  Given I start on the Edit Page for condition
  And I fill in "example_name" for "condition_name"
  And I press "Update Condition"
  Then I should see "example_name" 
