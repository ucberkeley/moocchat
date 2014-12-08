require 'spec_helper'

describe Task do

  describe 'creating' do
    it 'delegates :counter attribute' do
      (create :task).counter.should == 0
    end
    describe '2-page sequence' do
      before :each do
        @task = create(:task, :num_questions => 1)
        @task.condition.body_pages = [create(:template), create(:template)]
        @task.save!
      end
      it 'starts at 0' do ; @task.counter.should == 0 ; end
      it 'yields non-nil page' do ; @task.current_page.should be_a Template ; end
      describe 'when advanced & reloaded' do
        before :each do
          @task.next_page!
          @task.reload
        end
        it 'counts' do ; @task.counter.should == 1 ; end
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
        @activity_schema = mock_model(ActivitySchema, :valid? => true, :enabled? => true, :num_questions => 2)
        @condition = mock_model(Condition, :primary_activity_schema => @activity_schema, :valid? => true)
        @args = {
          :condition_id => @condition.id,
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
          its('condition.primary_activity_schema') { should == @activity_schema }
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
        @activity_schema = mock_model(ActivitySchema, :valid? => true, :enabled? => false, :num_questions => 2)
        @condition = mock_model(Condition, :primary_activity_schema => @activity_schema, :valid? => true)
        @args = {
          :condition_id => @condition.id,
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

  describe 'chat group name' do
    # create tasks with id's 200, 300, 800 to use in this test
    before :each do
      @tasks = Array.new(3) { create :task }
      @group = Task.chat_group_name_from_tasks(@tasks)
      @tasks.each { |t| t.assign_to_chat_group(@group, true) }
    end
    it 'forms group from sorted and unsorted task IDs' do
      Task.chat_group_name_from_tasks(@tasks.reverse).should == @group
    end
    it 'forms group from a single task' do
      Task.chat_group_name_from_tasks([@tasks.first]).should_not be_blank
    end
    it "retrieves learner index" do
      @tasks.sort_by(&:id).each_with_index do |task,i|
        task.learner_index.should == i
      end
    end
    describe 'raises error on learner index' do
      specify 'if not found' do
        @tasks[0].chat_group = "99999,88888"
        expect { @tasks[0].learner_index }.to raise_error Task::LearnerNotInGroupError
      end
      specify 'if nil' do
        @tasks[0].chat_group = nil
        expect { @tasks[0].learner_index }.to raise_error Task::LearnerNotInGroupError
      end
    end
  end

  describe 'logging' do
    it 'valid events' do
      (create :task).log('start')
    end
    it 'invalid event type raises RecordInvalid' do
      expect { (create :task).log('blah') }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

end
