Feature: assign learner to a chat group

  As a learner
  So that I can start my activity
  I want to get assigned to a chat group

Background:

  Given an enabled activity "Quiz review" that starts every 10 minutes
  And a condition "Chat 1"
  When I start activity "Quiz review" with condition "Chat 1" as "Armando"
  Then I should see "Greetings, Armando!"
  And I should see /"test_primary_activity_schema" will start automatically/
  And I should see a timer

Scenario: learner assigned to a chat group

  When the timer expires and the server assigns me to a chat group
  Then I should see "Page 0" within "span.counter"
  And I should see "<my chat group>" within "span.chat_group"
  And the following log entries should exist for that task in this order:
  | name       | chat_group      | counter |
  | start      |                 |         |
  | form_group | <my chat group> |         |
  | view_page  | <my chat group> |       0 |

Scenario: learner not assigned to any chat group

  When the timer expires and the server assigns me to no chat group
  Then I should not see "Page 0"
  But I should see "Please try this activity again later"
  And the following log entries should exist for that task in this order:
  | name   |
  | start  |
  | reject |

