Feature: Create Question as Administrator

  As an Administrator
  So that I define new Questions
  I want to create a question

Background:
  Given I am at the Questions Page
  And I follow "New"

Scenario: Create a question, valid conditions, Administrator
 
  When I fill in "Text text text" for "question_text"
  And I fill in "Question Explanation" for "question_explanation"
  And I fill in "Question Answers" for "question_Answer0"
  And I fill in "Question Answers" for "question_Answer1"
  And I fill in "Question Answers" for "question_Answer2"
  And I fill in "Question Answers" for "question_Answer3"
  And I fill in "Question Answers" for "question_Answer4"
  And I fill in "1" for "question_correct_answer_index"
  And I press "Create Question"
  Then I should see "Question"
  And I should see "Question Explanation"
 


 