require 'spec_helper'

describe TasksController do

  describe 'using Static page to create Task' do
    before :all do
      @c = Condition.create!(:name => "Chat Sequence 1")
      @a = ActivitySchema.create!(:name => "Quiz Review", :enabled => "true")
    end
    describe 'it visits the static page' do
      it 'fills in the right vales' do
        puts "****************"
        
        puts "****************"

        page.should have_content("Configueration Page for MoocChat")
        #fill_in 'learner_name', :with  => 'steven'
        #select 'Chat Sequence 1', :from => "condition_id[id]"
        #select 'Quiz Review', :from => "activity_schema_id[:id]"
      end
      it 'should create a new task using Static Post' do

      end
    end
  end

  describe 'task URI', :type => :routing do
    it 'creates new task on POST' do
      expect(:post => '/tasks/armandofox/237/15').to route_to(
        :controller => 'tasks',
        :action => 'create',
        :learner_name => 'armandofox',
        :activity_schema_id => '237',
        :condition_id => '15'
        )
    end
    it 'does not create task on GET' do
      expect(:get => '/tasks/armandofox/237/15').not_to be_routable
    end
    it 'routes to Welcome page' do
      expect(:get => '/tasks/10').to route_to :controller => 'tasks', :action => 'welcome', :id => '10'
    end
  end

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

  

end
