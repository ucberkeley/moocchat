Feature: Update Question as Administrator

  As an Administrator
  So that I modify the verbiage of a question
  I want to edit a Question

Background:
  Given a generated question with explanation "TO BE DETERMINED" 

Scenario: edit page, valid conditions, Administrator

  Given I start on the Edit Page for question
  When I fill in "Text text text" for "question_text"
  And I fill in "Question Explanation" for "question_explanation"
  And I press "Update Question"
  Then I should see "Question Explanation" 
  And I should see "Text text text"
