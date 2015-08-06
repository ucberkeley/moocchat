Feature: Create Condition as Administrator

  As an Administrator
  So that I set my Condtions
  I want to create a condition

Background:
  Given I am on the conditions page
  Given a pregenerated Template named "Default"
  Given a condition "Test"
  Given an activity schema "primary_activity_schema"
  Given an activity schema "time_filler_activity_schema"
  And I follow "New"

Scenario: Create a condition, valid conditions,Administrator
  When I fill in "Robert" for "condition_name"
  And I fill in "1" for "Body repeat count"
  And I select "Default" from "prologue_Pages0"
  And I select "Default" from "body_Pages1"
  And I select "Default" from "epilogue_Pages4"
  And I select "primary_activity_schema" from "primary_activity_schema_id"
  And I select "time_filler_activity_schema" from "time_filler_id"
  And I press "Create Condition"
  Then I should see "Default"
  Then I should see "primary_activity_schema"
  Then I should see "time_filler_activity_schema"

Scenario: Create a condition, missing primary_activity_schema,Administrator
  When I fill in "John" for "condition_name"
  When I select "Default" from "prologue_Pages0"
  And I select "Default" from "body_Pages1"
  And I select "Default" from "epilogue_Pages4"
  And I press "Create Condition"
  Then I should see "Primary activity schema can't be blank"

Scenario: Create a condition, missing name,Administrator
  When I select "Default" from "prologue_Pages0"
  And I select "Default" from "body_Pages1"
  And I select "Default" from "epilogue_Pages4"
  And I select "primary_activity_schema" from "primary_activity_schema_id"
  And I press "Create Condition"
  Then I should see "Name can't be blank"

Scenario: Create a condition, invalid group size,Administrator
  When I fill in "Robert" for "condition_name"
  And I select "Default" from "prologue_Pages0"
  And I select "Default" from "body_Pages1"
  And I select "Default" from "epilogue_Pages4"
  And I select "1" from "condition_preferred_group_size"
  And I select "6" from "condition_minimum_group_size"
  And I select "primary_activity_schema" from "primary_activity_schema_id"
  And I press "Create Condition"
  Then I should see "Minimum group size must be between 1 and preferred group size"

Scenario: Create a condition, duplicate name,Administrator
  When I fill in "Test" for "condition_name"
  And I select "Default" from "prologue_Pages0"
  And I select "Default" from "body_Pages1"
  And I select "primary_activity_schema" from "primary_activity_schema_id"
  And I press "Create Condition"
  Then I should see "Name has already been taken"

Scenario: Create a condition, invalid number of pages,Administrator
  When I fill in "Robert" for "condition_name"
  And I fill in "1" for "condition_body_repeat_count"
  And I select "primary_activity_schema" from "primary_activity_schema_id"
  And I press "Create Condition"
  Then I should see "Body pages must contain at least 1 page"

Scenario: Create a condition, 
