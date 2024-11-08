class Profile < ApplicationRecord
  belongs_to :user

  # ActiveStorage for attaching an avatar image
  has_one_attached :avatar, dependent: :purge_later

  validates :bio, presence: true
  validates :location, presence: true
  validate :acceptable_avatar # Validation for the avatar

  private

  # Custom validation for avatar file type and size
  def acceptable_avatar
    return unless avatar.attached?

    # Validate file type (only accept JPEG, PNG, or GIF)
    unless avatar.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:avatar, "must be a JPEG, PNG, or GIF")
    end

    # Validate file size (limit to 5MB)
    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "must be smaller than 5MB")
    end
  end
end