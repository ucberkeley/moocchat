@javascript
Feature: test learner starts task

  As an instructor or admin
  So that I can test out my condition flow
  I want to be a test learner who can skip past initial group-formation timer

@wip
Scenario: skip past welcome page timer

  When I start test driving condition "C1" with group size 1
  Then I should see /Your activity .* will start automatically/
  And I should not see "00:00" within the timer
  When I press "Form Groups Immediately"
  Then I should see "00:00" within the timer
