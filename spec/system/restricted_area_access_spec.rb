require "rails_helper"

RSpec.describe "Restricted Area Access", type: :system do
  include Devise::Test::IntegrationHelpers

  let!(:admin) { create(:user, :admin) }
  let!(:logistics_manager) { create(:user, :logistics_manager) }
  let!(:shipping_agent) { create(:user, :shipping_agent) }

  let!(:access_point_one) { create(:access_point, location: "Elevator", access_level: 2, description: "Elevator access point", status: "active") }
  let!(:access_point_two) { create(:access_point, location: "Stairwell", access_level: 3, description: "Stairwell access point", status: "active") }

  before do
    sign_in shipping_agent
  end

  scenario "Shipping agent requests access and gets approved" do
    visit root_path

    click_on "Account"
    within "ul.dropdown-menu" do
      click_on "Request Elevated Access"
    end

    select shipping_agent.full_name, from: "elevated_access_request[user_id]"
    select access_point_one.location, from: "elevated_access_request[access_point_id]"
    fill_in "elevated_access_request[reason]", with: "Need to deliver to restricted elevator floor."
    click_on "Request Elevated Access"

    expect(page).to have_text "Elevated access request was successfully created."

    # Log out the shipping agent and sign in the logistics manager
    sign_out shipping_agent
    sign_in logistics_manager
    visit elevated_access_requests_path

    # Find the request row by access point location and approve it
    row = find("tr", text: access_point_one.location)
    within row do
      click_on "Approve"
    end

    expect(page).to have_text "Approved"
  end

  scenario "Shipping agent requests access and gets denied" do
    visit root_path

    click_on "Account"
    within "ul.dropdown-menu" do
      click_on "Request Elevated Access"
    end

    select shipping_agent.full_name, from: "elevated_access_request[user_id]"
    select access_point_two.location, from: "elevated_access_request[access_point_id]"
    fill_in "elevated_access_request[reason]", with: "Need to deliver to high-clearance area."
    click_on "Request Elevated Access"

    expect(page).to have_text "Elevated access request was successfully created."

    # Log out the shipping agent and sign in the logistics manager
    sign_out shipping_agent
    sign_in logistics_manager
    visit elevated_access_requests_path

    # Find the request row by access point location and deny it
    row = find("tr", text: access_point_two.location)
    within row do
      click_on "Deny"
    end

    expect(page).to have_text "Denied"
  end

  scenario "View elevated access request details" do
    elevated_access_request = ElevatedAccessRequest.create!(
      user: shipping_agent,
      access_point: access_point_one,
      reason: "Need to check restricted area for maintenance.",
      status: 'pending'
    )

    visit elevated_access_request_path(elevated_access_request)

    expect(page).to have_text "Elevated Access Request Details"
    expect(page).to have_text elevated_access_request.user.full_name
    expect(page).to have_text elevated_access_request.access_point.location
    expect(page).to have_text elevated_access_request.reason
    expect(page).to have_text "Pending"
  end

  scenario "Pagination and filtering elevated access requests" do
    25.times do |i|
      ElevatedAccessRequest.create!(
        user: shipping_agent,
        access_point: access_point_one,
        reason: "Request number #{i}",
        status: 'pending'
      )
    end

    visit elevated_access_requests_path
    expect(page).to have_selector ".pagination"

    select shipping_agent.full_name, from: "user_id"
    click_on "Search"
    expect(page).to have_text "Request number 0"

    select access_point_one.location, from: "access_point_id"
    click_on "Search"
    expect(page).to have_text "Request number 0"
  end
end