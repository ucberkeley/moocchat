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
    chat_group '123'
    current_question 1
    completed false
  end

    
    
end

