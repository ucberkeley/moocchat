Feature: Delete template as Administrator

  As an Administrator
  So that I can remove unnessary Templates
  I want to be able to delete a template

Background:
	Given a pregenerated Template named "Default"

Scenario: Delete an activity schema, valid conditions, Administrator

  Given I am on the templates page
  When I follow "Delete"
  Then I should not see "Default"