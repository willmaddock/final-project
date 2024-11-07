class User < ApplicationRecord
  # Include default Devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum for roles, mapping symbols to integers
  enum role: { admin: 0, editor: 1, viewer: 2, shipping_agent: 3, logistics_manager: 4 }

  # Set a default role if none is provided when a new record is created
  after_initialize do
    self.role ||= :viewer if new_record?
  end

  # Establish the relationship with Profile
  has_one :profile

  # Optional: Add validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  # Optional: You can add additional methods or scopes related to users here
end