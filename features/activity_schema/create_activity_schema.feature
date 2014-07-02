Feature: Create Activity Schema as Administrator

  As an Administrator
  So that I can customize my Activity Schema
  I want to create an activity schema

Background:
  Given I am on the activity_schemas page
  And I follow "New"


Scenario: Create a activity schema, valid conditions, Administrator
  When I fill in "1" for "activity_schema_cohort_id"
  And I fill in "3" for "activity_schema_num_questions"
  And I fill in "now" for "activity_schema_tag"
  And I fill in "example" for "activity_schema_name"
  And I select "January 1, 2011, 5:00pm" as the "Start time" time
  And I select "11" from "activity_schema_start_time_4i"
  And I select "00" from "activity_schema_start_time_5i"
  And I select "July 26, 2015, 5:00pm" as the "End time" time
  And I select "11" from "activity_schema_end_time_4i"
  And I select "00" from "activity_schema_end_time_5i"
  And I fill in "6" for "activity_schema_starts_every" 
  And I press "Create Activity schema"
  Then I should see "example"

Scenario: Create a activity schema, starts every less than 5, Administrator
  When I fill in "1" for "activity_schema_cohort_id"
  And I fill in "3" for "activity_schema_num_questions"
  And I fill in "now" for "activity_schema_tag"
  And I fill in "example" for "activity_schema_name"
  And I select "January 1, 2011, 5:00pm" as the "Start time" time
  And I select "11" from "activity_schema_start_time_4i"
  And I select "00" from "activity_schema_start_time_5i"
  And I select "July 26, 2015, 5:00pm" as the "End time" time
  And I select "11" from "activity_schema_end_time_4i"
  And I select "00" from "activity_schema_end_time_5i"
  And I fill in "1" for "activity_schema_starts_every" 
  And I press "Create Activity schema"
  Then I should see "Starts every must be greater than or equal to 5"

Scenario: Create a activity schema, missing name, Administrator
  When I fill in "1" for "activity_schema_cohort_id"
  And I fill in "3" for "activity_schema_num_questions"
  And I fill in "now" for "activity_schema_tag"
  And I select "January 1, 2011, 5:00pm" as the "Start time" time
  And I select "11" from "activity_schema_start_time_4i"
  And I select "00" from "activity_schema_start_time_5i"
  And I select "July 26, 2015, 5:00pm" as the "End time" time
  And I select "11" from "activity_schema_end_time_4i"
  And I select "00" from "activity_schema_end_time_5i"
  And I fill in "1" for "activity_schema_starts_every" 
  And I press "Create Activity schema"
  Then I should see "Name can't be blank"


  Scenario: Create a activity schema, invalid conditions-end time earlier than start time, Administrator
  When I fill in "1" for "activity_schema_cohort_id"
  And I fill in "3" for "activity_schema_num_questions"
  And I fill in "now" for "activity_schema_tag"
  And I fill in "example" for "activity_schema_name"
  And I select "January 1, 2016, 5:00pm" as the "Start time" time
  And I select "11" from "activity_schema_start_time_4i"
  And I select "00" from "activity_schema_start_time_5i"
  And I select "July 26, 2015, 5:00pm" as the "End time" time
  And I select "11" from "activity_schema_end_time_4i"
  And I select "00" from "activity_schema_end_time_5i"
  And I fill in "1" for "activity_schema_starts_every" 
  And I press "Create Activity schema"
  Then I should see "End time must be later than start time"