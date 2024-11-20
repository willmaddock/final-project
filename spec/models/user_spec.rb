require 'rails_helper'

RSpec.describe User, type: :model do
  # Test 1: Validation of Essential Fields
  describe 'Validations' do
    it 'is invalid without a username' do
      user = build(:user, username: nil)
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  # Test 2: Uniqueness of Fields
  describe 'Uniqueness' do
    before { create(:user, username: 'uniqueuser', email: 'unique@example.com') }

    it 'is invalid with a duplicate username' do
      user = build(:user, username: 'uniqueuser', email: 'newemail@example.com')
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include('has already been taken')
    end

    it 'is invalid with a duplicate email' do
      user = build(:user, username: 'newuser', email: 'unique@example.com')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end
  end

  # Test 3: Role-Based Authorization
  describe 'Role-based Authorization' do
    it 'grants admin the ability to create items' do
      admin = build(:user, :admin)
      expect(admin.can_create_items?).to be true
    end

    it 'prevents shipping agent from creating items' do
      shipping_agent = build(:user, :shipping_agent)
      expect(shipping_agent.can_create_items?).to be false
    end

    it 'grants logistics manager permission to audit logs' do
      logistics_manager = build(:user, :logistics_manager)
      expect(logistics_manager.can_audit_logs?).to be true
    end
  end

  # Test 4: Status Change
  describe 'Status Change' do
    it 'toggles user status between active and inactive' do
      user = create(:user, status: true)

      # Initial status should be active
      expect(user.status).to be true

      # Toggle status
      user.toggle!(:status)
      expect(user.status).to be false

      # Toggle back to active
      user.toggle!(:status)
      expect(user.status).to be true
    end
  end
end