# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141225035602) do

  create_table "activity_schemas", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "cohort_id"
    t.boolean  "enabled"
    t.boolean  "randomized"
    t.integer  "num_questions"
    t.string   "tag"
    t.string   "name"
    t.text     "questions"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "starts_every"
  end

  create_table "cohorts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "cohorts_instructors", :id => false, :force => true do |t|
    t.integer "cohorts_id"
    t.integer "instructors_id"
  end

  create_table "cohorts_learners", :id => false, :force => true do |t|
    t.integer "cohorts_id"
    t.integer "learners_id"
  end

  create_table "conditions", :force => true do |t|
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "name"
    t.text     "prologue_pages"
    t.text     "body_pages"
    t.text     "epilogue_pages"
    t.integer  "preferred_group_size"
    t.integer  "minimum_group_size"
    t.integer  "body_repeat_count"
    t.integer  "primary_activity_schema_id"
    t.integer  "time_filler_id"
  end

  create_table "event_logs", :force => true do |t|
    t.text     "value"
    t.datetime "created_at",         :null => false
    t.string   "name"
    t.integer  "counter"
    t.integer  "subcounter"
    t.integer  "question_counter"
    t.string   "chat_group"
    t.integer  "question_id"
    t.integer  "task_id"
    t.integer  "learner_id"
    t.integer  "activity_schema_id"
    t.integer  "condition_id"
  end

  add_index "event_logs", ["activity_schema_id"], :name => "index_event_logs_on_activity_schema_id"
  add_index "event_logs", ["condition_id"], :name => "index_event_logs_on_condition_id"
  add_index "event_logs", ["learner_id"], :name => "index_event_logs_on_learner_id"
  add_index "event_logs", ["question_id"], :name => "index_event_logs_on_question_id"
  add_index "event_logs", ["task_id"], :name => "index_event_logs_on_task_id"

  create_table "questions", :force => true do |t|
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.text     "text"
    t.text     "answers"
    t.integer  "correct_answer_index"
    t.text     "explanation"
  end

  create_table "tasks", :force => true do |t|
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "learner_id"
    t.integer  "condition_id"
    t.string   "chat_group"
    t.boolean  "completed"
    t.text     "sequence_state"
    t.integer  "waiting_room_id"
    t.text     "user_state"
    t.datetime "start_page_time"
    t.string   "original_chat_group"
    t.datetime "last_heartbeat"
    t.text     "turk_params"
  end

  add_index "tasks", ["condition_id"], :name => "index_tasks_on_condition_id"
  add_index "tasks", ["learner_id"], :name => "index_tasks_on_learner_id"
  add_index "tasks", ["waiting_room_id"], :name => "index_tasks_on_waiting_room_id"

  create_table "templates", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.string   "url"
    t.text     "html"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "type"
    t.string   "name"
    t.boolean  "for_testing",       :default => false
    t.boolean  "consent"
    t.datetime "consent_timestamp"
    t.string   "email"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

  create_table "waiting_rooms", :force => true do |t|
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "condition_id"
    t.integer  "activity_schema_id"
    t.datetime "expires_at"
  end

  add_index "waiting_rooms", ["condition_id", "activity_schema_id"], :name => "index_waiting_rooms_on_condition_id_and_activity_schema_id", :unique => true

end
