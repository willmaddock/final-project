require "rails_helper"

RSpec.describe ElevatedAccessRequestsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/elevated_access_requests").to route_to("elevated_access_requests#index")
    end

    it "routes to #new" do
      expect(get: "/elevated_access_requests/new").to route_to("elevated_access_requests#new")
    end

    it "routes to #show" do
      expect(get: "/elevated_access_requests/1").to route_to("elevated_access_requests#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/elevated_access_requests/1/edit").to route_to("elevated_access_requests#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/elevated_access_requests").to route_to("elevated_access_requests#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/elevated_access_requests/1").to route_to("elevated_access_requests#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/elevated_access_requests/1").to route_to("elevated_access_requests#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/elevated_access_requests/1").to route_to("elevated_access_requests#destroy", id: "1")
    end
  end
end
