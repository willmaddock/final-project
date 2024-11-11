# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Test 1: Validation of Essential Fields
  describe 'Validations' do
    it 'is invalid without a username' do
      user = User.new(email: 'test@example.com', password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      user = User.new(username: 'testuser', password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  # Test 2: Uniqueness of Fields
  describe 'Uniqueness' do
    before do
      User.create!(username: 'uniqueuser', email: 'unique@example.com', password: 'password123')
    end

    it 'is invalid with a duplicate username' do
      user = User.new(username: 'uniqueuser', email: 'newemail@example.com', password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include('has already been taken')
    end

    it 'is invalid with a duplicate email' do
      user = User.new(username: 'newuser', email: 'unique@example.com', password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end
  end

  # Test 3: Role-Based Authorization
  describe 'Role-based Authorization' do
    it 'grants admin the ability to create items' do
      admin = User.create!(username: 'adminuser', email: 'admin@example.com', password: 'password123', role: 'admin')
      expect(admin.can_create_items?).to be true
    end

    it 'prevents shipping agent from creating items' do
      shipping_agent = User.create!(username: 'agentuser', email: 'agent@example.com', password: 'password123', role: 'shipping_agent')
      expect(shipping_agent.can_create_items?).to be false
    end

    it 'grants logistics manager permission to audit logs' do
      logistics_manager = User.create!(username: 'logisticsuser', email: 'logistics@example.com', password: 'password123', role: 'logistics_manager')
      expect(logistics_manager.can_audit_logs?).to be true
    end
  end

  # Test 4: Status Change
  describe 'Status Change' do
    it 'toggles user status between active and inactive' do
      user = User.create!(username: 'statususer', email: 'status@example.com', password: 'password123', active: true)

      # Initial status should be active
      expect(user.active).to be true

      # Toggle status
      user.toggle_active_status
      expect(user.active).to be false

      # Toggle back to active
      user.toggle_active_status
      expect(user.active).to be true
    end
  end
end