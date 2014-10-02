Feature: Update Template as Administrator

	As an Administrator
	So that I choose how to admistor a Task
	I want to edit a Template

Background:
	Given a pregenerated Template named "Default"

Scenario: edit page, valid conditions, Administrator

	Given I start on the Edit Page for template
	When I fill in "Non Default" for "Name"
	When I fill in "<h1>hello moocChat</h1>" for "HTML"
	And I press "Update Template"
	Then I should be on the templates page
        And I should see "successfully updated"
