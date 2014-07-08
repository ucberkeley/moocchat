Feature: visit next page of task

  As a learner doing a task
  So that I can make progress on the task
  I want to go to the next page

Scenario: Step through task

  Given a task with a 2-page condition repeated 1 time
  When I visit the first page of that task
  Then I should see "Page 0" within "span.counter"
  When I press "Continue"
  Then I should see "Page 1" within "span.counter"
  When I press "Continue"
  Then I should be on the home page
  And the following log entries should exist for that task in this order:
   | name      | counter |
   | start     |         |
   | view_page |       0 |
   | view_page |       1 |
   | finish    |         |
