Feature: delete template as Administrator

  As an Administrator
  So that I can't see the name of my template
  I want to delete a template

Background:

  Given a template "tempt1"

  Scenario: Delete an activity schema, valid conditions
  Given I am on the templates page
  When I follow "Delete"
  Then I should not see "tempt1"