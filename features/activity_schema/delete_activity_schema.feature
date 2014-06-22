Feature: delete activity schema as Administrator

  As an Administrator
  So that I can't see the name of my activity schema
  I want to delete an activity schema

Background:

  Given an activity schema "act1"

  Scenario: Delete an activity schema, valid conditions
  Given I am on the activity_schemas page
  When I follow "Delete"
  Then I should not see "example"