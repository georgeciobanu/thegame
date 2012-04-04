require "spec_helper"

describe EmailUpdatesController do
  describe "routing" do

    it "routes to #index" do
      get("/email_updates").should route_to("email_updates#index")
    end

    it "routes to #new" do
      get("/email_updates/new").should route_to("email_updates#new")
    end

    it "routes to #show" do
      get("/email_updates/1").should route_to("email_updates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/email_updates/1/edit").should route_to("email_updates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/email_updates").should route_to("email_updates#create")
    end

    it "routes to #update" do
      put("/email_updates/1").should route_to("email_updates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/email_updates/1").should route_to("email_updates#destroy", :id => "1")
    end

  end
end
