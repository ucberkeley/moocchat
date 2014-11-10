require 'spec_helper'

describe TaskHelper do
  describe 'time_filler' do
    let(:args) { {
      :name => 'x',
      :preferred_group_size => 2,
      :minimum_group_size => 1,
      :body_pages => [create(:template)],
      :time_filler => create(:activity_schema, :name => 'test_activity_schema', :questions => [create(:question)]),
      :body_repeat_count => 1
    }}
    it 'pass in nil questions does not break program' do
      cond2 = Condition.new(args.merge(:time_filler => nil))
      @questions = []
      expect{time_filler(cond2)}.not_to change {@questions}
    end
    it 'sets @questions' do
      cond = Condition.new(args)
      @questions = []
      expect{time_filler(cond)}.to change {@questions.length}.by(1)
    end
  end  
end
