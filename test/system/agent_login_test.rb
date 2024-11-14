require "application_system_test_case"

class AgentLoginTest < ApplicationSystemTestCase
  setup do
    # Load the shipping agent fixture
    @user = users(:shipping_agent)
    # Ensure password is set for testing
    @user.password = 'password'
    @user.password_confirmation = 'password'
    @user.save!
  end

  test "agent successfully logs in with valid credentials" do
    # Navigate to login page
    visit new_user_session_path

    # Fill in login form with valid credentials
    fill_in "Email", with: @user.email
    fill_in "Password", with: 'password'
    click_on "Log in"

    # Confirm successful login
    assert_text "Create your profile here to get started."
    assert_current_path root_path  # Use root_path if that's the home page
  end

  test "agent fails to log in with invalid credentials" do
    # Navigate to login page
    visit new_user_session_path

    # Attempt login with incorrect password
    fill_in "Email", with: @user.email
    fill_in "Password", with: 'incorrect_password'
    click_on "Log in"

    # Confirm login failure
    assert_text "Invalid Email or password."
    assert_current_path new_user_session_path
  end
end