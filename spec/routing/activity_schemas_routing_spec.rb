require "spec_helper"

describe ActivitySchemasController do
  describe "routing" do

    it "routes to #index" do
      get("/activity_schemas").should route_to("activity_schemas#index")
    end

    it "routes to #new" do
      get("/activity_schemas/new").should route_to("activity_schemas#new")
    end

    it "routes to #show" do
      get("/activity_schemas/1").should route_to("activity_schemas#show", :id => "1")
    end

    it "routes to #edit" do
      get("/activity_schemas/1/edit").should route_to("activity_schemas#edit", :id => "1")
    end

    it "routes to #create" do
      post("/activity_schemas").should route_to("activity_schemas#create")
    end

    it "routes to #update" do
      put("/activity_schemas/1").should route_to("activity_schemas#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/activity_schemas/1").should route_to("activity_schemas#destroy", :id => "1")
    end

  end
end
