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
    describe 'sets timer' do
      # for task starting every 5 mins, given current time, what should timer
      # countdown be?
      { 
        "12:01:00 pm" => 4.minutes,
        "12:01:45 pm" => 3.minutes + 15.seconds,
        "12:04:58 pm" => 2.seconds,
      }.each_pair do |now, time_to_go|
        specify "to #{Time.at(time_to_go).strftime('%M:%S')} if it's #{now}" do
          Timecop.freeze(now) do
            a = create :activity_schema, :starts_every => 5
            t = create :task, :activity_schema => a
            WaitingRoom.add(t).should == time_to_go
          end
        end
      end
    end
  end
  describe 'timer fuzzing' do
    # these tests depend on constants MAX_USERS and SERVICE_TIME_IN_MS
    # in waiting_room.rb.  If their values are changed, these tests will fail
    [ # normal fuzz amounts
      [ 100, 5 ],
      [ 1000, 50 ],
      # no fuzz needed
      [ 11, 0 ],
      [ 20, 0 ],
      # should not exceed expiration time of next task (here, 60 sec)
      [ 2000, 60 ],
      [ 2500, 60 ]
    ].each do |users,fuzz|
      it "adds #{fuzz}s when there are #{users} users" do
        Timecop.freeze(Time.zone.now) do
          @t = mock_model Task
          @t.stub_chain(:activity_schema, :starts_every).and_return(1)
          @w = WaitingRoom.new
          @w.expires_at = Time.zone.now
          @w.stub_chain(:tasks, :size).and_return(users)
          @w.timer_until(@t).should be_within(1).of(fuzz)
        end
      end
    end
  end
  describe 'expiration time' do
    [
      [6, 15, 18], [6, 0, 6], [6, 58, 0],
    ].each do |test_case|
      starts_every, minute_now, minute_to_expire = test_case
      specify "should be :#{'%02d' % minute_to_expire} if it's now :#{'%02d' % minute_now} and tasks are every #{starts_every} minutes" do
        a = create(:activity_schema, :starts_every => starts_every)
        Timecop.freeze(Time.now.change :min => minute_now, :sec => 0) do
          rollover = (minute_to_expire.zero? ? 1 : 0)
          (create(:waiting_room, :activity_schema => a)).expires_at.
            should == Time.now.change(:min => minute_to_expire, :sec => 0) + rollover.hours
        end
      end
    end
    it 'should be aligned on 1-minute boundary' do
      Timecop.freeze(Time.now.change :sec => 27) do
        (create :waiting_room).expires_at.sec.should == 0
      end
    end
  end
  it 'can be forced to process groups immediately' do
    @wr = create :waiting_room, :expires_at => 10.minutes.from_now
    @wr.force_group_formation_now!
    @wr.expires_at.should be < Time.zone.now
  end
    
  describe 'wakeup task' do
    before :each do
      @expiring = Array.new(3) { create(:waiting_room, :expires_at => 1.minute.ago) }
      @not_expiring = Array.new(2) { create(:waiting_room, :expires_at => 10.minutes.from_now) }
      WaitingRoom.process_all!
    end
    it 'processes & destroys expired waiting rooms' do
      @expiring.each do |wr|
        lambda { WaitingRoom.find(wr.id) }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
    it 'leaves alone unexpired waiting rooms' do
      @not_expiring.each { |wr| WaitingRoom.find(wr.id).should be_a WaitingRoom }
    end
  end
  describe 'processing' do
    before :each do
      @t = create(:task, :group_size => 2)
    end
  end
  describe 'creating groups' do
    # how to test transactional integrity, since we have to atomically
    # empty the waiting room and assign tasks to groups?
    before :each do
      @condition = create :condition
      @activity = create :activity_schema
    end
    # test cases:
    # q length, pref'd grp size, min grp size, expected #grps, expected #small grps, expected # rejects
    @tests = [
      [2, 1, 1, 2, 0, 0],
      [4, 1, 1, 4, 0, 0],
      [6, 2, 1, 3, 0, 0],
      [7, 2, 1, 3, 1, 0],
      [5, 4, 2, 1, 0, 1],
      [3, 5, 3, 0, 1, 0],
      # [3, 5, 2, 0, 1, 1], # Disabled for current run, should create as large groups as possible
      # [3, 5, 4, 0, 0, 3],
    ]
    @tests.each do |test_case|
      len,size,min_size,num_groups,num_small,num_rejects = test_case
      describe "Split #{len} learners into groups of #{size} and small-groups of #{min_size}" do
        before :each do
          @condition.update_attributes(:preferred_group_size => size, :minimum_group_size => min_size)
          len.times { WaitingRoom.add(create(:task, :condition => @condition, :activity_schema => @activity)) }
          @w = WaitingRoom.find_by_activity_schema_id_and_condition_id!(@activity.id, @condition.id)
          @w.process
          @tasks_by_chat_group = Task.all.group_by(&:chat_group) # ActiveRelation's GROUP and HAVING are wonky in PGSql
        end
        it "should create #{num_groups} large groups" do
          @tasks_by_chat_group.count { |group,grouparray| grouparray.length == size }.should == num_groups
        end
        it "should create #{num_small} small groups" do
          # special case: if pref'd group size is 1, there will never be any small groups,
          # and the below test will produce a false negative
          size == 1 ? true : (@tasks_by_chat_group.count { |group,grouparray| grouparray.length == min_size }.should == num_small)
        end
        it "should have #{num_rejects} rejects" do
          if num_rejects.zero?
            @tasks_by_chat_group['NONE'].should be_nil
          else
            @tasks_by_chat_group['NONE'].length.should == num_rejects
          end
        end
        it "should empty the waiting room" do
          @w.tasks.length.should == 0
        end
        it "should give a nonblank chat_group to every task" do
          @w.tasks.all { |task| task.chat_group.should_not be_blank }
        end
      end
    end
  end

end
