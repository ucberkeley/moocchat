require "spec_helper"

describe ConditionsController do
  describe "routing" do

    it "routes to #index" do
      get("/conditions").should route_to("conditions#index")
    end

    it "routes to #new" do
      get("/conditions/new").should route_to("conditions#new")
    end

    it "routes to #show" do
      get("/conditions/1").should route_to("conditions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/conditions/1/edit").should route_to("conditions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/conditions").should route_to("conditions#create")
    end

    it "routes to #update" do
      put("/conditions/1").should route_to("conditions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/conditions/1").should route_to("conditions#destroy", :id => "1")
    end

  end
end
