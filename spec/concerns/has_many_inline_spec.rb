require 'spec_helper'


describe HasManyInline, :pending => 'HasManyInline module completion' do
  class TestOwner
    include HasManyInline
  end
  class Thing ; end
  it 'provides has_many_inline method' do
    TestOwner.should respond_to :has_many_inline
  end
  describe 'getter' do
    before :all do ; TestOwner.send(:has_many_inline, :things) ; end
    it 'exists' do
      TestOwner.new.should respond_to :things
    end
    it 'attempts to lookup each record' do
      Thing.should_receive(:find).exactly(3).times.and_return(
        mock_model(Thing), mock_model(Thing), mock_model(Thing))
    end
  end
  describe 'provides' do
    describe 'getter' do
      subject { TestOwner.new.things }
      it { should be_a_kind_of Array }
      it { should be_empty }
    end
    it 'setter' 
  end
end

