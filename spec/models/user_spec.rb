require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(email: 'test@example.com', password: 'password')
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = User.new(email: nil, password: 'password')
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user = User.new(email: 'test@example.com', password: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid with an improperly formatted email' do
      user = User.new(email: 'invalid_email', password: 'password')
      expect(user).to_not be_valid
    end

    it 'is not valid with a short password' do
      user = User.new(email: 'test@example.com', password: 'short')
      expect(user).to_not be_valid
    end
  end
end