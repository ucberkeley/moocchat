Feature: I want to chat with two other learners
	
	As a Learner
  	So that I  am in a triade
  	I want to chat with two other learners

Background:
	Given I am on chat page

@javascript
Scenario: talk in the room
	When I fill in "A" for "input-handle"
	And I fill in "from A" for "input-text"
	And I press "send"
	Then I should see "A"
	Then I should see "from A"
	

Scenario: receive message
	