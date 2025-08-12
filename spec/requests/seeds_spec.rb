require 'rails_helper'

RSpec.describe "Seeds", type: :request do
  describe "GET /run" do
    it "returns http success" do
      get "/seeds/run"
      expect(response).to have_http_status(:success)
    end
  end

end
