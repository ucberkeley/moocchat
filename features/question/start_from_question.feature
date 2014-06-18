Feature: edit question as Administrator

  As an Administrator
  So that I update the answers selection to my questions
  I want to edit a question

  Scenario: Edit page, valid conditions, Administrator
  Given I am on the Questions Page
  When I press "EDIT"
  Then I should see "Answer Choices"

  @javascript
Scenario: Edit page, missing explanation, Administrator

  Given I am on the Questions Page
  When I press "EDIT"
  Then I should see a JS dialog saying "please fill out all the form"
