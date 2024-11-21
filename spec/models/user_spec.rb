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
    before do
      create(:user, username: 'uniqueuser', email: 'unique@example.com')
    end

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
      admin = create(:user, :admin)
      expect(admin.can_create_items?).to eq(true)
    end

    it 'prevents shipping agent from creating items' do
      shipping_agent = create(:user, :shipping_agent)
      expect(shipping_agent.can_create_items?).to eq(false)
    end

    it 'grants logistics manager permission to audit logs' do
      logistics_manager = create(:user, :logistics_manager)
      expect(logistics_manager.can_audit_logs?).to eq(true)
    end
  end

  # Test 4: Status Change
  describe 'Status Change' do
    it 'toggles user status between active and inactive' do
      user = create(:user, status: true)

      aggregate_failures 'Testing status toggling' do
        # Initial status should be active
        expect(user.status).to eq(true)

        # Toggle status to inactive
        user.toggle!(:status)
        expect(user.status).to eq(false)

        # Toggle back to active
        user.toggle!(:status)
        expect(user.status).to eq(true)
      end
    end
  end
end