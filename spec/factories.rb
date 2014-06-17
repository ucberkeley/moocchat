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
    prologue []
    body []
    epilogue []
  end

  factory :learner do
    name 'learner'
  end

  factory :task do
    learner { build :learner }
    condition { build :condition }
    chat_group nil
    completed false
    sequencer { Task::Sequencer.new }
  end

  factory :template do
    random = 
    url nil
    html '<!DOCTYPE html><html><head></head><body><p>PAGE_ID (<%= @page_id %>)</p></body></html>'
    name 'test'
    after :create do |template|
      template.update_attributes! :html => template.html.gsub(/PAGE_ID/, template.id)
    end
  end
  
end

