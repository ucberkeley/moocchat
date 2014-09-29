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

template_arr = []
Template.delete_all
Template.delete_all
template_files = File.join(Rails.root, 'db', '*.html')   # makes it easy to put templates somewhere else in future
template_files = Dir.glob(template_files).map do |filename|
    filename
end
template_files = template_files.sort

templates = template_files.map do |filename|
  html = IO.read(filename)
  name = if html.match( /<title>([^>]+)<\/title>/i ) then  $1 else File.basename(filename) end
  template_arr.push(Template.create! :name => name, :html => html)
end

Condition.delete_all
condition = Condition.create!(name: "Chat Sequence 1",
  prologue_pages: [],body_pages: template_arr, epilogue_pages: [],preferred_group_size: 2,
  minimum_group_size:1, body_repeat_count: 1)

Cohort.delete_all
cohort = Cohort.create!(name: "Cohort 1")

ActivitySchema.delete_all
activity_schema = ActivitySchema.create!(name: "Quiz Review", cohort: cohort, enabled: true, randomized: false,
  num_questions: 1, tag: "Quiz Review", questions: [Question.first],
  start_time: Time.zone.now.midnight, end_time: Time.zone.now + 2.days, starts_every: 1)

# delete any WaitingRooms, since they have foreign keys to activity schemas and conditions
WaitingRoom.delete_all

#For testing with admin button only:
learnerA = Learner.create!(:name => "Alex Testing")
learnerB = Learner.create!(:name => "Ben Testing")
learnerC = Learner.create!(:name => "Calvin Testing")
taskA = Task.create!(
      :condition => condition,
      :learner => learnerA,
      :completed => false,
      :chat_group => nil,
      :activity_schema => activity_schema,
      :sequence_state => nil
      )
taskB = Task.create!(
      :condition => condition,
      :learner => learnerB,
      :completed => false,
      :chat_group => nil,
      :activity_schema => activity_schema,
      :sequence_state => nil
      )
taskC = Task.create!(
      :condition => condition,
      :learner => learnerC,
      :completed => false,
      :chat_group => nil,
      :activity_schema => activity_schema,
      :sequence_state => nil
      )
taskA.fill_sequence_state
taskB.fill_sequence_state
taskC.fill_sequence_state