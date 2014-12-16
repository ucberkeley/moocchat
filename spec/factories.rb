# To test out factories in console, start with
#   rails console --sandbox
# and in console say
#   include FactoryGirl::Syntax::Methods
# You can then say stuff like
#  task = create(:task)
# Note that you have to restart console if you modify this file.

module FactoryHelpers
  def self.task_template(next_question)
    %Q{
<!DOCTYPE html>
<html>
<head>
  <%= javascript_include_tag 'application' %>
  <title>Page <%= @counter %></title>
</head>
<body>} <<
      yield <<
      %Q{<%= form_tag task_next_page_path(@task) do %>
  <input type="hidden" name="next_question" value="#{next_question}">
  <%= submit_tag "Continue" %>
<% end %>
</body></html>}
  end
end


FactoryGirl.define do

  factory :activity_schema do
    cohort { create :cohort }
    enabled true
    randomized false
    num_questions 1
    questions { Array.new(num_questions) { create(:question) } }
    tag ''
    name 'activity'
    start_time 1.day.from_now.midnight
    end_time   2.days.from_now.midnight
    starts_every 30             # minutes
  end

  factory :cohort do
    name 'cohort'
  end

  factory :condition do
    sequence(:name) { |n| "Condition#{n}" }
    preferred_group_size 3
    minimum_group_size 1
    prologue_pages []
    body_pages { [create(:template)] }
    epilogue_pages []
    body_repeat_count 1
    primary_activity_schema {create :activity_schema, :questions => [create(:question)]}    
    time_filler {create :activity_schema, :questions => [create(:question)]}
  end

  %w(learner instructor administrator).each do |user_type|
    factory user_type do
      sequence(:name) { |n| "#{user_type}#{n}" }
    end
  end
  
  factory :question do
    sequence(:text) { |n| "Question #{n}" }
    answers ["Wrong", "Wrong", "Right"]
    correct_answer_index 2
    explanation ""
  end

  factory :task do
    ignore do
      num_questions 2
      body_repeat_count 1
      group_size 2
    end
    learner { create :learner }
    condition { create :condition, :body_repeat_count => body_repeat_count, :preferred_group_size => group_size, :primary_activity_schema => create(:activity_schema, :num_questions => num_questions), :time_filler => create(:activity_schema, :questions => [create(:question)])}
    sequence_state { Task::Sequencer.new(:body_repeat_count => body_repeat_count, :num_questions => num_questions) }
    chat_group nil
    completed false
    user_state nil
  end

  trait :with_chat_group do
    after :create do |task, evaluator|
      task.update_attribute :chat_group, Task.chat_group_name_from_tasks([task])
    end
  end

  factory :template do
    ignore do
      next_question ''
    end
    #
    #  DO NOT REMOVE any of the stuff inside div.debugging, as it is used
    #  by various Cucumber scenarios!  It's fine to add stuff there for your
    #  own tests.
    #
    url nil
    name 'test'
    html do
      FactoryHelpers::task_template(next_question) do
      %Q{
<div class="debugging">
  <span class="task_id">Task <%= @task_id %></span>
  <span class="counter">Page <%= @counter %></span>
  <span class="subcounter">Subcounter <%= @subcounter %></span>
  <span class="question">Question <%= @question_counter %></span>
  <span class="chat_group">Chat group <%= @chat_group %></span>
</div>}
      end
    end
  end

  factory :template_with_chat, :class => Template do
    ignore do
      next_question ''
    end
    url nil
    name 'chat_test'
    html do
      FactoryHelpers::task_template(next_question) do
      %Q{
<div class="chat">
 <%= chat %>
</div>
}
      end
    end
  end

  factory :waiting_room do
    condition { create(:condition, :primary_activity_schema => create(:activity_schema), :time_filler => create(:activity_schema, :questions => [create(:question)]))}
  end
end
