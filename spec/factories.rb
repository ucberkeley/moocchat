FactoryGirl.define do

  factory :condition do
    name 'dummy condition'
    prologue ''
    body ''
    epilogue ''
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

