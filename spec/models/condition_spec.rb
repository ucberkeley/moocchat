require 'spec_helper'

describe Condition do
  describe 'basic model' do
    let(:args) { {
        :name => 'x',
        :preferred_group_size => 2,
        :minimum_group_size => 1,
        :body_pages => [create(:template)],
        :primary_activity_schema =>create(:activity_schema, :name => 'primary_activity_schema', :questions => [create(:question)]),
        :time_filler => create(:activity_schema, :name => 'test_activity_schema', :questions => [create(:question)]),
        :body_repeat_count => 1
      }}
    it 'should be valid with valid args' do
      Condition.new(args).should be_valid
    end
    specify 'minimum group size <= preferred group size' do
      c = Condition.new(args.merge(:minimum_group_size => 3))
      c.should_not be_valid
    end
    specify 'repeat count >= 1' do
      c = Condition.new(args.merge(:body_repeat_count => 0))
      c.should_not be_valid
      c.should have(1).error_on(:body_repeat_count)
    end
    it 'allows fixed group size' do
      Condition.new(args.merge(:minimum_group_size => 2)).should be_valid
    end
    it 'disallows huge groups' do
      Condition.new(args.merge(:preferred_group_size => 100)).should_not be_valid
    end
    it 'allows singletons' do
      Condition.new(args.merge(:minimum_group_size => 1)).should be_valid
    end
    it 'requires a name' do
      Condition.new(args.except(:name)).should_not be_valid
    end

    it 'returns time_filler_questions correctly' do
      c = Condition.new(args)
      questions = c.time_filler_questions
      questions.should_not be_nil
      questions.should have_exactly(1).items
      questions.each do |question|
        question.should be_a(Question)
      end
    end
  end

end


