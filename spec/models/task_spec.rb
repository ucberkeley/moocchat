require 'spec_helper'

describe Task do

  describe 'creating from POST params' do
    context 'when learner does not exist' do
      before :each do
        @condition = mock_model(Condition, :valid? => true)
        @activity_schema = mock_model(ActivitySchema, :valid? => true)
        @args = {
          :condition_id => @condition.id,
          :activity_schema_id => @activity_schema.id,
          :learner_name => 'joe'
        }
        Condition.stub(:find).and_return(@condition)
        ActivitySchema.stub(:find).and_return(@activity_schema)
      end
      it 'creates new learner' do
        expect { Task.create_from_params @args }.to change { Learner.count }.by(1)
      end
      describe 'creates valid task' do
        subject { Task.create_from_params @args }
        it { should be_valid }
        its(:current_question) { should == 1 }
        its(:condition) { should == @condition }
        its(:activity_schema) { should == @activity_schema }
      end
      context 'when learner already exists' do
        before :each do
          # use FactoryGirl to create the learner named 'joe' in advance
          @learner = create(:learner, :name => 'joe')
        end
        it 'does not create new learner' do
          expect { Task.create_from_params @args }.not_to change { Learner.count }
        end
        describe 'creates valid task' do
          subject { Task.create_from_params @args }
          it { should be_valid }
          its(:learner) { should == @learner }
        end
      end
    end
  end

end
