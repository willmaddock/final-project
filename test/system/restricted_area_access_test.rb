require "application_system_test_case"
require 'bcrypt'

class RestrictedAreaAccessTest < ApplicationSystemTestCase
  setup do
    # Create user instances and hash passwords manually
    @shipping_agent = users(:shipping_agent)
    @shipping_agent.password_digest = BCrypt::Password.create('password')
    @shipping_agent.save

    @no_clearance_agent = users(:no_clearance_agent)
    @no_clearance_agent.password_digest = BCrypt::Password.create('password')
    @no_clearance_agent.save

    @restricted_access_point = access_points(:restricted_area)
    @elevated_access_request = ElevatedAccessRequest.create(user: @shipping_agent, access_point: @restricted_access_point, status: 'pending', reason: "Need access for delivery")
  end

  test "agent has the necessary clearance and can access the restricted area" do
    sign_in @shipping_agent

    visit elevated_access_requests_path
    click_on "New Elevated Access Request"

    select @shipping_agent.full_name, from: "Select User"
    select @restricted_access_point.location, from: "Select Access Point"
    click_on "Submit"

    assert_text "Elevated access request was successfully created."
    assert_equal "approved", @elevated_access_request.reload.status
  end

  test "agent lacks the necessary clearance and cannot access the restricted area" do
    sign_in @no_clearance_agent

    visit elevated_access_requests_path
    click_on "New Elevated Access Request"

    select @no_clearance_agent.full_name, from: "Select User"
    select @restricted_access_point.location, from: "Select Access Point"
    click_on "Submit"

    assert_text "Access denied"
    assert_no_text "Elevated access request was successfully created."
  end
end