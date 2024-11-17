require 'test_helper'

class ElevatedAccessRequestTest < ActiveSupport::TestCase
  setup do
    @shipping_agent = users(:shipping_agent)
    @access_point = access_points(:one)
    @elevated_access_request = ElevatedAccessRequest.new(
      user: @shipping_agent,
      access_point: @access_point,
      reason: "Need to deliver to restricted elevator floor."
    )
  end

  test "should be valid with valid attributes" do
    assert @elevated_access_request.valid?
  end

  test "should not be valid without a user" do
    @elevated_access_request.user = nil
    assert_not @elevated_access_request.valid?
  end

  test "should not be valid without an access point" do
    @elevated_access_request.access_point = nil
    assert_not @elevated_access_request.valid?
  end
end