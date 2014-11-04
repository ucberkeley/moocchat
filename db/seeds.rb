#encoding: utf-8 
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

require 'yaml'
Question.delete_all
YAML.load_file('db/questions.yml').each do |question|
  Question.create!(
    :text => question['text'],
    :answers => question['answers'],
    :correct_answer_index => question['correct_answer_index'],
    :explanation => "To be determined")
end

# Default template page

Template.delete_all
template_glob = File.join(Rails.root, 'db', '*.html')   # makes it easy to put templates somewhere else in future
files = Dir.glob(template_glob).sort
template_arr = files.map do |filename|
  html = IO.read(filename)
  name = if html.match( /<title>([^>]+)<\/title>/i ) then  $1 else File.basename(filename) end
  Template.create! :name => name, :html => html
end

ActivitySchema.delete_all
activity_schema = ActivitySchema.create!(name: "Quiz Review", cohort: cohort, enabled: true, randomized: false,
  num_questions: 1, tag: "Quiz Review", questions: [Question.first],
  start_time: Time.zone.now.midnight, end_time: Time.zone.now + 2.days, starts_every: 1)

time_filler_activity_schema = ActivitySchema.create!(name: "time_filler_Quiz_Review", cohort: cohort, enabled: true, randomized: false,
  num_questions: Question.all.length, tag: "Quiz Review", questions: Question.all,
  start_time: Time.zone.now.midnight, end_time: Time.zone.now + 2.days, starts_every: 1)

Condition.delete_all
condition = Condition.create!(name: "Chat Sequence 1",
  prologue_pages: [],body_pages: template_arr, epilogue_pages: [],preferred_group_size: 2,
  minimum_group_size:1, body_repeat_count: 1)

Cohort.delete_all
cohort = Cohort.create!(name: "Cohort 1")

# delete any WaitingRooms, since they have foreign keys to activity schemas and conditions
WaitingRoom.delete_all

User.delete_all
(1..3).each do |num|
  learner = Learner.create! :name => "Learner #{num}"
  learner.update_attribute(:for_testing, true)
end
