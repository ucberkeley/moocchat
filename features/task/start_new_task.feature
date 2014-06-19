Feature: start new task

  As a learner
  So that I can participate in a peer learning activity
  I want to start a new task using instructor-provided link

Scenario: valid condition and activity schema, new learner

  Given a new learner named "Armando"
  And an activity schema "Quiz review"
  And a condition "Chat sequence 1"
  When I post to the URL for learner: "Armando", activity schema: "Quiz review", condition: "Chat sequence 1"
  Then I should see "Greetings, Armando!" 
  And I should see /Click below to start "Quiz review"/
