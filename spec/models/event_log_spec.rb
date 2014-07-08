require 'spec_helper'

describe EventLog do
  describe 'when created' do
    before :each do
      @t = create :task
      @valid_args = {:task => @t, :activity_schema => @t.activity_schema,
        :condition => @t.condition, :learner => @t.learner,
        :name => EventLog::EVENTS.first}
    end
    it 'is valid with valid args' do
      EventLog.new(@valid_args).should be_valid
    end
    [:activity_schema, :condition, :learner].each do |attr|
      specify "requires valid #{attr}" do
        @valid_args.delete(attr)
        (e = EventLog.new(@valid_args)).should_not be_valid
        e.should have(1).error_on(attr)
      end
    end
    context 'if value-bearing' do
      context 'but no value supplied' do
        subject { EventLog.new(@valid_args.merge(:name => EventLog::EVENTS_WITH_VALUES.first)) }
        it { should_not be_valid }
        it { should have(1).errors_on('value') }
      end
      it 'is valid if value supplied' do
        EventLog.new(
          @valid_args.merge(:name => EventLog::EVENTS_WITH_VALUES.first, :value => 'x')).
          should be_valid
      end
    end
  end
end
