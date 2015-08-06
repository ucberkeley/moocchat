require 'spec_helper'

describe TasksController do
  describe 'establishing session' do
    before :all do 
      @dummy_params = {:learner_name => 'x', :condition_id => '1' }
    end
    describe 'successfully' do
      before :each do
        @t = create :task
        Task.stub(:create_from_params).and_return(@t)
      end
      it 'redirects to task welcome page' do
        post :create, @dummy_params
        response.should redirect_to task_welcome_path(@t)
      end
      it 'adds the task to a waiting room' do
        WaitingRoom.should_receive(:add).with(@t)
        post :create, @dummy_params
      end
      it 'sets the timer based on waiting room processing interval' do
        WaitingRoom.stub(:add).and_return(53)
        post :create, @dummy_params
        assigns(:timer).should == 53
      end
      it 'logs the creation of the task' do
        WaitingRoom.stub(:add)
        expect(@t).to receive(:log).with(:start)
        post :create, @dummy_params
      end
    end
    it 'when activity is not enabled shows an error' do
      Task.stub(:create_from_params).and_raise Task::ActivityNotOpenError
      post :create, @dummy_params
      response.should redirect_to task_error_path
    end      
    context 'when error occurs' do
      before :each do ; Task.stub(:create_from_params).and_raise(ActiveRecord::RecordNotFound) ; end
      it 'logs the error' do
        Rails.logger.should_receive(:error)
        post :create, @dummy_params
      end
      it 'shows error page' do
        post :create, @dummy_params
        response.should redirect_to task_error_path
      end
    end
  end

  describe 'recording answer' do
    before :each do
      @task = create :task
      @user_state = {'foo' => '1', 'bar' => "bar", 'baz' => '["x","y"]'}
    end
    it 'gives an error if not AJAX (XHR) post' do
      post :collect_response, :id => @task, :u => @user_state
      response.code.should == '403'
    end
    it 'logs the event' do
      xhr :post, :collect_response, :id => @task, :u => @user_state
      EventLog.find_all_by_task_id_and_name(@task, :user_state).each do |e|
        key,val = e.value.split '='
        @user_state[key].should == val
      end
    end
    it 'saves user state encoded as params[:u]' do
      xhr :post, :collect_response, :id => @task, :u => @user_state
      @task.reload.user_state.should == @user_state
    end
    it 'does not overwrite user state if params[:u] absent' do
      @task.update_attribute :user_state, {'x' => '1'}
      xhr :post, :collect_response, :id => @task
      @task.reload.user_state.should == {'x' => '1'}
    end
    it 'serves user state when next page is displayed' do
      Task.any_instance.stub(:current_page).and_return(Template.first)
      @task.update_attribute(:user_state, @user_state)
      @task.assign_to_chat_group(Task.chat_group_name_from_tasks([@task]), true)
      get :page, :id => @task
      assigns(:u).should == @user_state
    end
  end

  describe "other users' state" do
    before :each do
      @t = Array.new(3)  { |n| create(:task, :user_state => {'val' => n}) }
      chat_group = Task.chat_group_name_from_tasks(@t)
      @t.each { |task| task.assign_to_chat_group(chat_group, true) }
    end
    it "sets @me" do
      @t.each_with_index do |task,n|
        get :page, :id => task
        assigns(:me).should == n
      end
    end
    it 'assigns @u' do
      @t.each_with_index do |task,n|
        get :page, :id => task
        assigns(:u).should == task.user_state
      end
    end
    it 'assigns other learners data' do
      u = @t.first.user_state_for_all
      @t.each_with_index do |task,n|
        assigns(:data) == task.user_state
      end
    end
    it 'only modifies my own data' do
      post :next_page, :id => @t[1], :params=>{:data=>[{'answer'=>'1'}]}
      @t[1].user_state.should == {'val' => 1}
    end
    it 'sets the start time offset' do
      Task.any_instance.stub(:start_page_time).and_return(3)
      get :page, :id => @t[1]
      assigns(:offset).should be > 0
    end
  end
  
  describe 'logging' do
    before :each do ; @task = create :task, :with_chat_group  ; end
    it 'via regular POST gives a Forbidden error' do
      post :log, :id => @task
      response.code.should == '403'
    end
    context 'via AJAX POST' do
      it 'logs valid event' do
        expect { xhr :post, :log, :id => @task, :name => 'continue'}.
          to change { EventLog.count }.by(1)
      end
      it 'extracts name from params' do
        t = mock_model(Task).as_null_object
        Task.should_receive(:find).with(@task.id.to_s).and_return(t)
        t.should_receive(:log).with('continue', anything())
        xhr :post, :log, :id => @task, :name => 'continue'
      end
    end
  end

  describe 'next_question field' do
    before :each do ; @task = create :task ; end
    it 'advances to next question if nonblank' do
      expect { post :next_page, :id => @task, :next_question => 'true' }.
        to change { @task.reload.question_counter }.by(1)
    end
    it 'does not change question if blank' do
      expect { post :next_page, :id => @task }.not_to change { @task.reload.question_counter }
    end
  end

  it 'sets up template variables' do
    @task = create :task, :user_state => {'foo' => '1'}
    @task.assign_to_chat_group(group = Task.chat_group_name_from_tasks([@task]), true)
    get :page, :id => @task
    assigns(:task_id).to_i.should == @task.id
    assigns(:question).should be_a Question
    assigns(:counter).should be_an_integer
    assigns(:subcounter).should be_an_integer
    assigns(:question_counter).should be_an_integer
    assigns(:chat_group).should == group
    assigns(:start_form_tag).should have_xpath( %Q{//form[@data-log-url="#{task_collect_response_path(@task.id)}"][@action="#{task_next_page_path(@task.id)}"]})
    assigns(:u).should == {'foo' => '1'}
    assigns(:data).should be_an Array
    assigns(:me).should == 0
    assigns(:submit_to).should == task_next_page_path(@task)
  end
end
