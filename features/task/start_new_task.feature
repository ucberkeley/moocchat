Feature: start new task

  As a learner
  So that I can participate in a peer learning activity
  I want to start a new task using instructor-provided link

Scenario: valid condition, new learner

  Given a new learner named "Armando"
  And a condition "Chat sequence 1"
  When I post to the URL for learner: "Armando", condition: "Chat sequence 1"
  Then I should see "Greetings, Armando!" 
  And I should see /"test_primary_activity_schema" will start automatically/
