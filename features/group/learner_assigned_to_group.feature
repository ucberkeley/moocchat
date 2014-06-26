Feature: assign learner to a chat group

  As a learner
  So that I can start my activity
  I want to get assigned to a chat group

Background:

  Given an enabled activity "Quiz review" that starts every 10 minutes
  And a condition "Chat 1"
  When I start activity "Quiz review" with condition "Chat 1" as "Armando"
  Then I should see "Greetings, Armando!"
  And I should see /"Quiz review" will start automatically/
  And I should see a timer

Scenario: learner assigned to a chat group

  When the server assigns me to chat group "1,2,3"
  And the timer expires
  Then I should see "Page 1"

Scenario: learner not assigned to any chat group

  When the server does not assign me to any chat group
  And the timer expires
  Then I should not see "Page 1"
  But I should see "Please try this activity again later"
