FactoryGirl.define do

  factory :activity_schema do
    cohort { build :cohort }
    enabled true
    randomized false
    num_questions 1
    tag ''
    name 'activity'
  end

  factory :cohort do
    name 'cohort'
  end

  factory :condition do
    name 'dummy condition'
    prologue_pages []
    body_pages { [create(:template)] }
    epilogue_pages []
  end

  factory :learner do
    name 'learner'
  end

  factory :task do
    ignore do
      num_questions 2
    end
    learner { build :learner }
    condition { build(:condition) }
    chat_group nil
    completed false
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
  
end

