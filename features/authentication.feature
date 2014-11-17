@auth_test
Feature: authentication

  So that I can limit access to sensitive functions
  As the app administrator
  I want to limit actions to Instructors and Admins with registered Google IDs

Scenario: non-logged-in user cannot see sensitive pages

  When I go to the questions page
  Then I should see "You must be an Instructor or Administrator to do this action."
  And I should be on the home page

Scenario: successful login via Google

  Given an Instructor "Armando Fox" with Google email "armandofox@gmail.com"
  When I login successfully via Google as "Armando Fox <armandofox@gmail.com>"
  And I go to the questions page
  Then I should see "armandofox@gmail.com"
  And I should be on the questions page

Scenario: Google login, but user not authorized locally

  Given a Learner "Armando Fox" with Google email "armandofox@gmail.com"
  When I login successfully via Google as "Armando Fox <armandofox@gmail.com>"
  Then I should see "Sorry, armandofox@gmail.com isn't an instructor or administrator."
  And I should be on the home page

Scenario: failed login via Google  
