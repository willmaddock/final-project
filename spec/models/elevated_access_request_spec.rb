require 'rails_helper'

RSpec.describe ElevatedAccessRequest, type: :model do
  let(:shipping_agent) { create(:user, :shipping_agent) }
  let(:access_point) { create(:access_point) }
  let(:elevated_access_request) do
    build(
      :elevated_access_request,
      user: shipping_agent,
      access_point: access_point,
      reason: "Need to deliver to restricted elevator floor."
    )
  end

  context "with valid attributes" do
    it "is valid" do
      expect(elevated_access_request).to be_valid
    end
  end

  context "without a user" do
    it "is not valid" do
      elevated_access_request.user = nil
      expect(elevated_access_request).not_to be_valid
    end
  end

  context "without an access point" do
    it "is not valid" do
      elevated_access_request.access_point = nil
      expect(elevated_access_request).not_to be_valid
    end
  end
end