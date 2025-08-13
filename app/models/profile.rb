class Profile < ApplicationRecord
  belongs_to :user

  # Comments on this profile
  has_many :comments, dependent: :destroy

  # ActiveStorage for attaching an avatar image
  has_one_attached :avatar, dependent: :purge_later

  # Validations
  validates :user_id, uniqueness: true, presence: true
  validates :bio, presence: true
  validates :location, presence: true
  validate :acceptable_avatar  # Custom validation for avatar

  private

  # Validate avatar file type and size
  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:avatar, "must be a JPEG, PNG, or GIF")
    end

    if avatar.blob.byte_size > 1.megabytes
      errors.add(:avatar, "must be smaller than 5MB")
    end
  end
end