require 'rails_helper'

RSpec.describe 'Agent Login', type: :system do
  # Create a user with the shipping_agent trait, using a password of 'password'
  let(:user) { create(:user, :shipping_agent, password: 'password', password_confirmation: 'password') }

  describe 'successful login' do
    it 'allows the agent to log in with valid credentials' do
      # Navigate to login page
      visit new_user_session_path

      # Fill in the login form with valid credentials
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'

      # Confirm successful login and redirection
      expect(page).to have_text('Create your profile here to get started.')
      expect(current_path).to eq(root_path)  # Adjust to your actual home page path
    end
  end

  describe 'failed login' do
    it 'does not allow the agent to log in with invalid credentials' do
      # Navigate to login page
      visit new_user_session_path

      # Attempt login with incorrect password
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'incorrect_password'
      click_on 'Log in'

      # Confirm login failure
      expect(page).to have_text('Invalid Email or password.')
      expect(current_path).to eq(new_user_session_path)
    end
  end
end