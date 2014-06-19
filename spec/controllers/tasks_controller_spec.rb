# encoding: UTF-8
require 'spec_helper'

describe TasksController do
  describe 'establishing session' do
    before :all do 
      @dummy_params = { :activity_schema_id => '0', :learner_name => 'x', :condition_id => '1' }
    end
    it 'when successful redirects to task welcome page' do
      Task.stub(:create_from_params).and_return(@t = mock_model(Task, :enabled? => true))
      post :create, @dummy_params
      response.should redirect_to task_welcome_path(@t)
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

  describe 'user state' do
    before :each do
      @task = create :task
      @user_state = {'foo' => '1', 'bar' => "bar", 'baz' => '["x","y"]'}
    end
    it 'saves user state encoded as params[:u]' do
      post :next_page, :id => @task, :u => @user_state
      @task.reload.user_state.should == @user_state
    end
    it 'does not overwrite user state if params[:u] absent' do
      @task.update_attribute :user_state, {'x' => '1'}
      post :next_page, :id => @task
      @task.reload.user_state.should == {'x' => '1'}
    end
    it 'serves user state when next page is displayed' do
      Task.any_instance.stub(:current_page).and_return(Template.first)
      @task.update_attribute :user_state, @user_state
      get :page, :id => @task
      assigns(:u).should == @user_state
    end
  end

  it 'sets up template variables' do
    @task = create :task, :user_state => {'foo' => '1'}
    get :page, :id => @task
    assigns(:task_id).to_i.should == @task.id
    assigns(:question).should be_a_kind_of Question
    assigns(:counter).should be > 0
    assigns(:u).should be_a Hash
    assigns(:submit_to).should == task_next_page_path(@task)
  end
end
