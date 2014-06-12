require 'spec_helper'

describe Task do

  describe 'creating' do
    context 'when activity is enabled' do
      before :each do
        @condition = mock_model(Condition, :valid? => true)
        @activity_schema = mock_model(ActivitySchema, :valid? => true, :enabled? => true)
        @args = {
          :condition_id => @condition.id,
          :activity_schema_id => @activity_schema.id,
          :learner_name => 'joe'
        }
        Condition.stub(:find).and_return(@condition)
        ActivitySchema.stub(:find).and_return(@activity_schema)
      end
      context 'and new learner:' do
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
      end
      context 'and existing learner:' do
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
    context 'when activity is not enabled' do
      before :each do
        @condition = mock_model(Condition, :valid? => true)
        @activity_schema = mock_model(ActivitySchema, :valid? => true, :enabled? => false)
        @args = {
          :condition_id => @condition.id,
          :activity_schema_id => @activity_schema.id,
          :learner_name => 'joe'
        }
        Condition.stub(:find).and_return(@condition)
        ActivitySchema.stub(:find).and_return(@activity_schema)
      end
      it 'raises exception' do
        expect { Task.create_from_params @args }.to raise_error(Task::ActivityNotOpenError)
      end
      it 'does not create task' do
        expect { lambda { Task.create_from_params @args }}.not_to change { Task.count }
      end
    end
  end
end
