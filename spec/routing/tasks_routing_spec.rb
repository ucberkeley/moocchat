describe TasksController do
  describe "routing" do
    it "routes to #static" do
      get("/").should route_to("tasks#static")
    end
  end
end