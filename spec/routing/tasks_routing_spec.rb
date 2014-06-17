require "spec_helper"

describe TasksController do
  describe "routing" do
  	
    it "routes to tasks#static" do
    	expect(get("/")).to route_to("tasks#static")
    end
  end
end