Feature: Update Condition as Administrator

  As an Administrator
  So that I configure my specific condition
  I want to be able to edit a condition

Background:
  Given a pregenerated Template named "Default"
  Given a condition "Default"

Scenario: edit page, valid conditions, Administrator

  Given I start on the Edit Page for condition
  And I fill in "Steven" for "condition_name"
  And I select "Default" from "prologue_Pages0"
  And I press "Update Condition"
  Then I should redirect to the show page for condition
  And I should see "Steven" 