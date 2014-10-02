Feature: Delete Activity Schema as Administrator

  As an Administrator
  So that I can't see the name of my Activity Schema
  I want to delete an activity schema

Background:

  Given an activity schema "act1"

Scenario: Delete an activity schema, valid conditions
  Given I am on the activity schemas page
  When I follow "Delete" within the table row containing "act1"
  Then I should be on the activity schemas page
  Then I should not see "act1"
