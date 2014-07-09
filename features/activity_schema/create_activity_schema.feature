Feature: Create Activity Schema as Administrator

  As an Administrator
  So that I can customize my Activity Schema
  I want to create an activity schema

Background:
  Given I am on the activity_schemas page
  And a generated question with explanation "UC Berkeley" 
  And I follow "New"

Scenario: Create a activity schema, valid conditions, Administrator
  When I fill in "1" for "activity_schema_cohort_id"
  And I fill in "3" for "activity_schema_num_questions"
  And I fill in "now" for "activity_schema_tag"
  And I fill in "example" for "activity_schema_name"
  And I select "January 1, 2011" as the "Start time" date
  And I select "05:00" as the "activity_schema_start_time" time
  And I select "July 26, 2015" as the "End time" date
  And I select "05:00" as the "activity_schema_end_time" time
  And I fill in "6" for "activity_schema_starts_every"
  And I fill in "2" for "activity_schema_num_questions"
  And I select "1" from "questions0"
  And I select "1" from "questions1"
  And I press "Create Activity schema"
  Then I should see "example"

Scenario: Create a activity schema, missing name, Administrator
  When I fill in "1" for "activity_schema_cohort_id"
  And I fill in "3" for "activity_schema_num_questions"
  And I fill in "now" for "activity_schema_tag"
  And I select "January 1, 2011" as the "Start time" date
  And I select "05:00" as the "activity_schema_start_time" time
  And I select "July 26, 2015" as the "End time" date
  And I select "05:00" as the "activity_schema_end_time" time
  And I fill in "1" for "activity_schema_starts_every" 
  And I press "Create Activity schema"
  Then I should see "Name can't be blank"


  Scenario: Create a activity schema, invalid conditions-end time earlier than start time, Administrator
  When I fill in "1" for "activity_schema_cohort_id"
  And I fill in "3" for "activity_schema_num_questions"
  And I fill in "now" for "activity_schema_tag"
  And I fill in "example" for "activity_schema_name"
  And I select "January 1, 2011" as the "Start time" date
  And I select "05:00" as the "activity_schema_start_time" time
  And I select "July 26, 2010" as the "End time" date
  And I select "05:00" as the "activity_schema_end_time" time
  And I fill in "1" for "activity_schema_starts_every" 
  And I press "Create Activity schema"
  Then I should see "End time must be later than start time"
