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

  describe 'chat group name' do
    # create tasks with id's 200, 300, 800 to use in this test
    before :each do
      TASK_IDS = [200,300,800]
      @tasks = Array.new(3) do |i|
        t = create(:task)
        Task.connection.execute(
          "UPDATE tasks SET id=#{TASK_IDS[i]} WHERE id=#{t.id}")
        t
      end
    end
    # list of tasks, chat channel, indices
    [
      [300,200,800], '200,300,800', [1,0,2],
      [200,300,800] , '200,300,800', [0,1,2],
      [300], '300', [0]
    ].each_slice(3) do |test_case|
      task_ids, group, indices = test_case
      it "is formed by sorting #{task_ids}" do
        list = Task.find task_ids
        Task.chat_group_name_from_tasks(list).should == group
      end
    end
    it "retrieves learner index" do
      @tasks = Array.new(3) { create :task }
      @group = Task.chat_group_name_from_tasks(@tasks)
      @tasks.each_with_index do |task,i|
        task.learner_index(@group).should == i
      end
    end
    it 'raises error if learner index not found' do
      expect { @tasks[0].learner_index("99999,88888") }.
        to raise_error Task::LearnerNotInGroupError
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
