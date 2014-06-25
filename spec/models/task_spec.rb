require 'spec_helper'

describe Task do

  describe 'creating' do
    it 'delegates :counter attribute' do
      (create :task).counter.should == 1
    end
    describe '2-page sequence' do
      before :each do
        @task = create(:task, :num_questions => 1)
        @task.condition.body_pages = [create(:template), create(:template)]
        @task.save!
      end
      it 'starts at 1' do ; @task.counter.should == 1 ; end
      it 'yields non-nil page' do ; @task.current_page.should be_a Template ; end
      describe 'when advanced & reloaded' do
        before :each do
          @task.next_page!
          @task.reload
        end
        it 'counts to 2' do ; @task.counter.should == 2 ; end
      end
      describe 'when advanced twice' do
        before :each do
          @task.next_page!
          @task.next_page!
          @task.reload
        end
        it 'yields no more pages' do ; @task.current_page.should be_nil ; end
        it 'idempotently yields no more pages' do
          @task.current_page
          @task.current_page.should be_nil
        end
      end
    end
    context 'when activity is enabled' do
      before :each do
        @condition = mock_model(Condition, :valid? => true)
        @activity_schema = mock_model(ActivitySchema, :valid? => true, :enabled? => true, :num_questions => 2)
        @args = {
          :condition_id => @condition.id,
          :activity_schema_id => @activity_schema.id,
          :learner_name => 'joe'
        }
        Condition.stub(:find).and_return(@condition)
        ActivitySchema.stub(:find).and_return(@activity_schema)
      end
      shared_examples_for 'starting task' do
        describe 'creates valid task' do
          subject { Task.create_from_params @args }
          it { should be_valid }
          its(:condition) { should == @condition }
          its(:activity_schema) { should == @activity_schema }
          its('learner.name') { should == 'joe' }
        end
      end
      context 'and new learner:' do
        it 'creates new learner' do
          expect { Task.create_from_params @args }.to change { Learner.count }.by(1)
        end
        it_should_behave_like 'starting task'
      end
      context 'and existing learner:' do
        before :each do
          # use FactoryGirl to create the learner named 'joe' in advance
          @learner = create(:learner, :name => 'joe')
        end
        it 'does not create new learner' do
          expect { Task.create_from_params @args }.not_to change { Learner.count }
        end
        it_should_behave_like 'starting task'
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

  describe 'user state' do
    
  end
end
