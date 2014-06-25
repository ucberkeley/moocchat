Feature: Delete question as Administrator

  As an Administrator
  So that I can remove unnessary Questions
  I want to delete a question

Background:

  Given a generated question with explanation "quest1"

  Scenario: Delete a question, valid conditions
  Given I am on the questions page
  When I follow "Delete"
  Then I should not see "quest1"

@javascript
Scenario: Delete a question, Testing JS, valid conditions, Administrator
  Given I am on the questions page
  When I follow "Delete"
  Then I should see a JS dialog saying "Are you sure?"
  Then I should not see "quest1"