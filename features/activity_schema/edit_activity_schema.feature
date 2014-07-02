Feature: update activity schema as Administrator

  As an Administrator
  So that I update the name of my activity schema
  I want to edit an activity schema

Background:

  Given an activity schema "act1"

Scenario: edit page, valid conditions, Administrator

  Given I start on the Edit Page for activity_schema
  When I fill in "new_name" for "activity_schema_name"
  And I press "Update Activity schema"
  Then I should see "new_name" 

Scenario: edit page, invalid conditions-starts every not divisible by 60, Administrator

  Given I start on the Edit Page for activity_schema
  When I fill in "14" for "activity_schema_starts_every" 
  And I press "Update Activity schema"
  Then I should see "Starts every must divide evenly into 60"

Scenario: edit page, invalid conditions-starts time not align with boundary, Administrator

  Given I start on the Edit Page for activity_schema
  When I fill in "15" for "activity_schema_starts_every"
  And I select "06" from "activity_schema_start_time_5i"
  And I select "27" from "activity_schema_end_time_5i"
  And I press "Update Activity schema"
  Then I should see "Start time must align with an activity boundary (:00, :15, :30, etc.)"