Feature: Update Condition as Administrator

  As an Administrator
  So that I configure my specific condition
  I want to be able to edit a condition

Background:
  Given a pregenerated Template named "Default"
  Given a condition "Default"
  Given an activity schema "new_time_filler"
  Given an activity schema "new_primary_activity_schema"

Scenario: edit page, valid conditions, Administrator

  Given I start on the Edit Page for condition
  And I fill in "Steven" for "condition_name"
  And I select "Default" from "body_Pages0"
  And I select "new_time_filler" from "time_filler_id"
  And I select "new_primary_activity_schema" from "primary_activity_schema_id"
  And I press "Update Condition"
  Then I should redirect to the show page for condition
  And I should see "Condition was successfully updated." 
  And I should see "new_time_filler"
  And I should see "new_primary_activity_schema"

