FactoryGirl.define do

  factory :activity_schema do
    cohort { build :cohort }
    enabled true
    randomized false
    num_questions 1
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
  end

  factory :learner do
    sequence(:name) { |n| "Learner#{n}" }
  end

  factory :task do
    ignore do
      num_questions 2
    end
    learner { build :learner }
    condition { build(:condition) }
    chat_group nil
    completed false
    user_state nil
    activity_schema { build :activity_schema, :num_questions => num_questions }
    sequence_state { Task::Sequencer.new(self.activity_schema.num_questions) }
  end

  factory :template do
    url nil
    html '<!DOCTYPE html><html><head><title>Page <%= @counter %></title></head><body>
<div class="counter"> Page <%= @counter %></div>
<div class="question">Question <%= @question.id %></div>
<div class="footer">  <%= "#{@task_id},#{@template_id},#{@counter}" %></div>
<%= form_for task_next_page_path(@task) do |f| %>
  <%= f.submit "Continue" %>
<% end %>
</body></html>'
    name 'test'
  end

  factory :waiting_room do
    condition { create :condition }
    activity_schema { create :activity_schema }
  end
end

