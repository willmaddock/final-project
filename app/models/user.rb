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

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :role, inclusion: { in: %w[shipping_agent viewer] } # Ensure only allowed roles can be assigned

  # Permission Methods
  def can_create_items?
    admin? || logistics_manager?  # Shipping agents cannot create items
  end

  def can_view_items?
    viewer? || shipping_agent? || logistics_manager?
  end

  def can_edit_items?
    admin? || editor? || logistics_manager?
  end

  def can_delete_items?
    admin? || logistics_manager?
  end

  def can_request_access?
    shipping_agent?
  end

  def can_audit_logs?
    logistics_manager?
  end
end