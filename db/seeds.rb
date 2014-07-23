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

#template_arr = []
Template.delete_all
# Template.delete_all
# template_files = File.join(Rails.root, 'db', '*.html')   # makes it easy to put templates somewhere else in future
# templates = Dir.glob(template_files).map do |filename|
#   html = IO.read(filename)
#   name = if html.match( /<title>([^>]+)<\/title>/i ) then  $1 else 'Default' end
#   template_arr.push(Template.create! :name => name, :html => html)
# end
template1 = Template.create! :name => 'learnerq', :html => IO.read('db/learnerresponse_template.html')
template2 = Template.create! :name => 'chatr', :html => IO.read('db/chatresponse_template.html')
template3 = Template.create! :name => 'assumption', :html => IO.read('db/identify_assumption_template.html')
template4 = Template.create! :name => 'answer', :html => IO.read('db/show_answer_template.html')


Condition.delete_all
Condition.create!(name: "Chat Sequence 1",
  prologue_pages: [],body_pages: [template3,template1,template2,template4], epilogue_pages: [],preferred_group_size: 2,
  minimum_group_size:1, body_repeat_count: 1)

Cohort.delete_all
cohort = Cohort.create!(name: "Cohort 1")

ActivitySchema.delete_all
ActivitySchema.create!(name: "Quiz Review", cohort: cohort, enabled: true, randomized: false,
  num_questions: 1, tag: "Quiz Review", questions: [Question.first],
  start_time: Time.zone.now.midnight, end_time: Time.zone.now + 2.days, starts_every: 1)

# delete any WaitingRooms, since they have foreign keys to activity schemas and conditions
WaitingRoom.delete_all
