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
  And I select "2014" from "activity_schema_start_time_1i"
  And I select "June" from "activity_schema_start_time_2i"
  And I select "25" from "activity_schema_start_time_3i"
  And I select "11" from "activity_schema_start_time_4i"
  And I select "00" from "activity_schema_start_time_5i"
  And I select "2014" from "activity_schema_end_time_1i"
  And I select "July" from "activity_schema_end_time_2i"
  And I select "26" from "activity_schema_end_time_3i"
  And I select "11" from "activity_schema_end_time_4i"
  And I select "00" from "activity_schema_end_time_5i"
  And I fill in "6" for "activity_schema_starts_every" 
  And I press "Create Activity schema"
  Then I should see "example"
  

