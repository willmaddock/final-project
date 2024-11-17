require "application_system_test_case"

class RestrictedAreaAccessTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:one)
    @logistics_manager = users(:two)
    @shipping_agent = users(:shipping_agent)

    # Create access points with appropriate validations
    @access_point_one = AccessPoint.create!(
      location: "Elevator",
      access_level: 2,
      description: "Elevator access point",
      status: "active"
    )
    @access_point_two = AccessPoint.create!(
      location: "Stairwell",
      access_level: 3,
      description: "Stairwell access point",
      status: "active"
    )

    # Sign in the shipping agent
    sign_in @shipping_agent
  end

  test "Scenario 1: Shipping agent requests access and gets approved" do
    visit root_path

    # Navigate to the Elevated Access Request form
    click_on "Account"
    within "ul.dropdown-menu" do
      click_on "Request Elevated Access"
    end

    # Fill out and submit the form
    select @shipping_agent.full_name, from: "elevated_access_request[user_id]"
    select @access_point_one.location, from: "elevated_access_request[access_point_id]"
    fill_in "elevated_access_request[reason]", with: "Need to deliver to restricted elevator floor."
    click_on "Request Elevated Access"

    assert_text "Elevated access request was successfully created."

    # Approve the request
    sign_out @shipping_agent
    sign_in @logistics_manager
    visit elevated_access_requests_path

    row = find("tr", text: @access_point_one.location)
    within row do
      click_on "Approve"
    end

    assert_selector "tr", text: "Approved"
  end

  test "Scenario 2: Shipping agent requests access and gets denied" do
    visit root_path

    # Navigate to the Elevated Access Request form
    click_on "Account"
    within "ul.dropdown-menu" do
      click_on "Request Elevated Access"
    end

    # Fill out and submit the form
    select @shipping_agent.full_name, from: "elevated_access_request[user_id]"
    select @access_point_two.location, from: "elevated_access_request[access_point_id]"
    fill_in "elevated_access_request[reason]", with: "Need to deliver to high-clearance area."
    click_on "Request Elevated Access"

    assert_text "Elevated access request was successfully created."

    # Deny the request
    sign_out @shipping_agent
    sign_in @logistics_manager
    visit elevated_access_requests_path

    row = find("tr", text: @access_point_two.location)
    within row do
      click_on "Deny"
    end

    assert_selector "tr", text: "Denied"
  end

  test "Scenario 3: View elevated access request details" do
    elevated_access_request = ElevatedAccessRequest.create!(
      user: @shipping_agent,
      access_point: @access_point_one,
      reason: "Need to check restricted area for maintenance.",
      status: 'pending'
    )

    visit elevated_access_request_path(elevated_access_request)

    # Validate details page
    assert_text "Elevated Access Request Details"
    assert_text elevated_access_request.user.full_name
    assert_text elevated_access_request.access_point.location
    assert_text elevated_access_request.reason
    assert_text "Pending"
  end

  test "Scenario 4: Pagination and filtering elevated access requests" do
    25.times do |i|
      ElevatedAccessRequest.create!(
        user: @shipping_agent,
        access_point: @access_point_one,
        reason: "Request number #{i}",
        status: 'pending'
      )
    end

    visit elevated_access_requests_path
    assert_selector ".pagination"

    # Apply filtering
    select @shipping_agent.full_name, from: "user_id"
    click_on "Search"
    assert_text "Request number 0"

    select @access_point_one.location, from: "access_point_id"
    click_on "Search"
    assert_text "Request number 0"
  end
end