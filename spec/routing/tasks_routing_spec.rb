require "spec_helper"

describe TasksController do
  describe "routing" do
    it "routes to tasks#static" do
    	expect(get("/")).to route_to("tasks#static")
    end
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
    it 'routes to page render' do
      expect(:get => '/tasks/10/page').to route_to :controller => 'tasks', :action => 'page', :id => '10'
    end
    it 'cannot post to page render' do
      expect(:post => '/tasks/10/page').not_to be_routable
    end
    it 'routes to join-group page' do
      expect(:post => '/tasks/9/join_group').to route_to :controller => 'tasks', :action => 'join_group', :id => '9'
    end
    it 'routes next-page action' do
      expect(:post => '/tasks/9/next_page').to route_to :controller => 'tasks', :action => 'next_page', :id => '9'
    end
    it 'routes the error page' do
      expect(:get => '/tasks/error').to route_to :controller => 'tasks', :action => 'error'
    end
  end
end
