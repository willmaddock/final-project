require "application_system_test_case"

class RestrictedAreaAccessTest < ApplicationSystemTestCase
  setup do
    # Setup fixtures for different user roles
    @admin = users(:one)
    @logistics_manager = users(:two)
    @shipping_agent = users(:shipping_agent)

    # Example Access Points with required validations
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

    # Login as shipping agent for the tests
    sign_in @shipping_agent
  end

  test "Scenario 1: Shipping agent requests access and gets approved" do
    # Navigate to new elevated access request form
    visit new_elevated_access_request_path

    # Debug: Print the HTML to ensure the form is rendered
    puts page.body

    # Ensure form elements exist and are accessible
    assert_selector "form#new_elevated_access_request"
    assert_selector "select#elevated_access_request_user_id"
    assert_selector "select#elevated_access_request_access_point_id"
    assert_selector "textarea#elevated_access_request_reason"

    # Fill out the elevated access request form
    select @shipping_agent.full_name, from: "elevated_access_request_user_id"
    select @access_point_one.location, from: "elevated_access_request_access_point_id"
    fill_in "elevated_access_request_reason", with: "Need to deliver to restricted elevator floor."

    # Submit the form and check success message
    click_on "Request Elevated Access"
    assert_text "Elevated access request was successfully created."

    # Simulate Logistics Manager actions: View and approve the request
    sign_out
    sign_in @logistics_manager
    visit elevated_access_requests_path

    # Logistics Manager views the request and approves it
    click_on "View Details", match: :first
    assert_text @access_point_one.location
    assert_text @shipping_agent.full_name
    assert_text "Need to deliver to restricted elevator floor."

    # Approve the request
    click_on "Approve Request"
    assert_text "Request was successfully approved."
  end

  test "Scenario 2: Shipping agent requests access and gets denied" do
    # Navigate to new elevated access request form
    visit new_elevated_access_request_path

    # Debug: Print the HTML to ensure the form is rendered
    puts page.body

    # Ensure form elements exist and are accessible
    assert_selector "form#new_elevated_access_request"
    assert_selector "select#elevated_access_request_user_id"
    assert_selector "select#elevated_access_request_access_point_id"
    assert_selector "textarea#elevated_access_request_reason"

    # Fill out the elevated access request form
    select @shipping_agent.full_name, from: "elevated_access_request_user_id"
    select @access_point_two.location, from: "elevated_access_request_access_point_id"
    fill_in "elevated_access_request_reason", with: "Need to deliver to high-clearance area."

    # Submit the form and check success message
    click_on "Request Elevated Access"
    assert_text "Elevated access request was successfully created."

    # Simulate Logistics Manager actions: View and deny the request
    sign_out
    sign_in @logistics_manager
    visit elevated_access_requests_path

    # Logistics Manager views the request and denies it
    click_on "View Details", match: :first
    assert_text @access_point_two.location
    assert_text @shipping_agent.full_name
    assert_text "Need to deliver to high-clearance area."

    # Deny the request
    click_on "Deny Request"
    assert_text "Request was successfully denied."
  end

  test "Scenario 3: View elevated access request details" do
    # Create a pending request for the test
    elevated_access_request = ElevatedAccessRequest.create!(
      user: @shipping_agent,
      access_point: @access_point_one,
      reason: "Need to check restricted area for maintenance.",
      status: 'pending'
    )

    # Visit the request details page
    visit elevated_access_request_path(elevated_access_request)

    # Ensure the details are displayed correctly
    assert_text "Elevated Access Request Details"
    assert_text elevated_access_request.user.full_name
    assert_text elevated_access_request.access_point.location
    assert_text elevated_access_request.reason
    assert_text "Pending"  # Status should be 'pending' initially
  end

  test "Scenario 4: Pagination and filtering elevated access requests" do
    # Create multiple requests to test pagination and filters
    25.times do |i|
      ElevatedAccessRequest.create!(
        user: @shipping_agent,
        access_point: @access_point_one,
        reason: "Request number #{i}",
        status: 'pending'
      )
    end

    # Visit the requests page
    visit elevated_access_requests_path

    # Ensure pagination is displayed
    assert_selector ".pagination"

    # Check if filtering by user works
    select @shipping_agent.full_name, from: "Select User:"
    click_on "Search"
    assert_text "Request number 1"  # Assert that one of the requests shows up

    # Check if filtering by access point works
    select @access_point_one.location, from: "Select Access Point:"
    click_on "Search"
    assert_text "Request number 1"  # Assert that one of the requests shows up
  end

  private

  # Utility method to sign in users
  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password" # Assuming fixtures use the default password
    click_on "Log in"
  end

  # Utility method to sign out users
  def sign_out
    click_on "Logout" if has_link?("Logout")
  end
end