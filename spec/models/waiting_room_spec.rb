require 'spec_helper'

describe WaitingRoom do
  describe 'adding task' do
    before :each do ; @t = create(:task) ; end
    it 'creates waiting room when doesn\'t exist for this activity/condition' do
      expect { WaitingRoom.add(@t) }.to change { WaitingRoom.count }.by 1
    end
    it 'does not create waiting room if it exists' do
      create :waiting_room, :activity_schema => @t.activity_schema, :condition => @t.condition
      expect { WaitingRoom.add(@t) }.not_to change { WaitingRoom.count }
    end
    it 'raises exception if same task added >1 time' do
      WaitingRoom.add @t
      expect { WaitingRoom.add @t }.to raise_error(WaitingRoom::TaskAlreadyWaitingError)
    end
  end
  describe 'processing' do
    # how to test transactional integrity, since we have to atomically
    # empty the waiting room and assign tasks to groups?
    before :each do
      @condition = create :condition
      @activity = create :activity_schema
      @args = {:condition => @condition, :activity_schema => @activity}
    end
    describe 'splitting' do
      context 'a queue of 6 into groups of 2' do
        before :each do
          @condition.update_attributes(:preferred_group_size => 2, :minimum_group_size => 1)
          6.times { WaitingRoom.add(create(:task, @args)) }
          @w = WaitingRoom.find_by_activity_schema_id_and_condition_id!(@condition.id, @activity.id)
          @w.process
        end
        it 'should result in 3 chat groups' do
          Task.count('chat_group', :distinct => true).should == 3
        end
        it 'should empty the waiting room' do
          @w.tasks.length.should == 0
        end
      end
    end
  end

end
