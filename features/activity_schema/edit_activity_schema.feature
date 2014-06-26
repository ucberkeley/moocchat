Feature: update activity schema as Administrator

  As an Administrator
  So that I update the name of my activity schema
  I want to edit an activity schema

Background:

  Given an activity schema "act1"

Scenario: edit page, valid conditions, Administrator

  Given I start on the Edit Page for activity_schema
  When I fill in "new_name" for "activity_schema_name"
  And I press "Update Activity schema"
  Then I should see "new_name" 