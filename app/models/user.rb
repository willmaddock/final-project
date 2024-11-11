class User < ApplicationRecord
  # Include default Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { admin: 0, editor: 1, viewer: 2, shipping_agent: 3, logistics_manager: 4 }

  after_initialize do
    self.role ||= :viewer if new_record? && role.nil?
  end

  # Relationships
  has_one :profile, dependent: :destroy
  has_many :access_logs, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :role, inclusion: { in: roles.keys }

  # Status toggle method for easy testing
  def toggle_active_status
    update(active: !active)
  end

  # Permission methods
  def can_create_items?
    admin? || logistics_manager?
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