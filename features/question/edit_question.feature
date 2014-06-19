Feature: update question as Administrator

  As an Administrator
  So that I update the answers selection to my questions
  I want to edit a question

Background:
  Given a generated question with explanation "TO BE DETERMINED" 

Scenario: edit page, valid conditions, Administrator

  Given I start on the Edit Page
  When I fill in "Text text text" for "question_text"
  And I fill in "Question Explanation" for "question_explanation"
  And I press "Update Question"
  Then I should see "Question Explanation" 

