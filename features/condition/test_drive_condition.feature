Feature: test drive a condition

  As an instructor
  So that I can ensure my experimental condition looks the way I intend
  I want to test drive the condition as a singleton learner

Background: singleton-friendly condition exists

  Given a condition "C1" with group size 1..3

Scenario: test drive as singleton learner

  Given I am on the conditions page
  When I press "Test Drive" within the table row containing "C1"
  Then I should see /Greetings, Learner \d!/
