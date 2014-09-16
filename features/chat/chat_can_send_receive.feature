Feature: Chat can send and receive message

  As a learner
  So that I can chat with other learners
  I want to send and receive chat message

Background:

  Given I am a learner assigned to a singleton waiting room
  When I have advanced to a chat page
  
 
Scenario: sends and receives the same message1

  When I send "Hello World" as my chat text
  And I wait for 2 seconds
  Then show me the page
  Then the chat box should contain "Hello World"

Scenario: sends and receives the same message2	

  When I send "Hello World" as my chat text
  And I wait for 2 seconds 
  Then the chat box should contain2 //
