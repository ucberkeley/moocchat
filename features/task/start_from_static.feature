Feature: start new task using Static Page

  As a learner
  So that I choose which peer learning activity to participate
  I want to start a new task using MoocChat's static page

Background:

  Given a condition "Chat sequence 1"
  Given an activity schema "Quiz review"

Scenario: static root page, new learner

  Given I start on the Static Page
  When I fill in "Steven" for "learner_name"
  And I select "Chat sequence 1" from "Condition"
  And I select "Quiz review" from "Activity"
  When I press "SUBMIT"
  Then I should see "Greetings, Steven!" 
  And I should see /Click below to start "Quiz review"/

@javascript
Scenario: static root page, missing activity schema, new learner

  Given I start on the Static Page
  When I fill in "Learner name" with "Robert"
  And I select "Chat sequence 1" from "Condition"
  And I press "SUBMIT"
  Then I should see a JS dialog saying "please fill out all the form"
  But I should not see "Welcome, Steven!" 
