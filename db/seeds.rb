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
    :correct_answer_index => question['correct_answer_index'])
end

# Default template page

Template.delete_all
template1 = Template.create! :name => 'Default', :html => IO.read('db/chat_template.html.erb')

Condition.delete_all
Condition.create!(name: "Chat Sequence 1",
  prologue_pages: [],body_pages: [template1], epilogue_pages: [],preferred_group_size: 2,
  minimum_group_size:1, body_repeat_count: 1)

Cohort.delete_all
cohort = Cohort.create!(name: "Cohort 1")

ActivitySchema.delete_all
ActivitySchema.create!(name: "Quiz Review", cohort: cohort, enabled: true, randomized: false,
  num_questions: 1, tag: "Quiz Review", questions: [Question.first],
  start_time: Time.zone.now.midnight, end_time: Time.zone.now + 2.days, starts_every: 2)

# delete any WaitingRooms, since they have foreign keys to activity schemas and conditions
WaitingRoom.delete_all
