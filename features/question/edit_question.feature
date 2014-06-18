Feature: update question as Administrator

  As an Administrator
  So that I update the answers selection to my questions
  I want to edit a question

Scenario: edit page, valid conditions, Administrator

  Given I start on the Edit Page
  When I fill in "Question Text" for "question_text"
  And I fill in "1" in "Question Answers" for "question_answers"
  And I select fill in "Question Explanation" for "question_explanation"
  And I fill in "1" in "question_correct_answer_index"
  When I press "Update Question"
  Then I should see "Question Explanation" 

@javascript
Scenario: edit page, missing explanation, Administrator

  Given I start on the Edit Page
  When I fill in "Question Text" for "question_text"
  And I fill in "1" in "Question Answers" for "question_answers"
  And I fill in "1" in "question_correct_answer_index"
  When I press "Update Question"
  Then I should see a JS dialog saying "please fill out all the form"
  But I should not see "Question Text" 