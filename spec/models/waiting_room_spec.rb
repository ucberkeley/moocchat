require 'spec_helper'

describe WaitingRoom do
  describe 'adding task' do
    before :each do ; @t = create :task ; end
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

end
