Feature: delete question as Administrator

  As an Administrator
  So that I can't see the name of my question
  I want to delete a question

Background:

  Given a generated question with explanation "quest1"

  Scenario: Delete a question, valid conditions
  Given I am on the questions page
  When I follow "Delete"
  Then I should not see "quest1"