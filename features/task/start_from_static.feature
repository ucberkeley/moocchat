Feature: start new task using Static Page

  As a learner
  So that I choose which peer learning activity to participate
  I want to start a new task using MoocChat's static page

Scenario: static root page, new learner

  Given I am on root_page
  When I fill in "Steven" for "learner name"
  And I select "chat sequence 1" for "Condtion"
  And I select "Quiz Review" for "Activity Schema"
  When I click submit
  Then I should see "Welcome, Steven!" 
  And I should see /Click below to start "Quiz review"/