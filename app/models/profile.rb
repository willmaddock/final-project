class Profile < ApplicationRecord
  belongs_to :user
  validates :bio, presence: true
  validates :location, presence: true
  validates :avatar, presence: true
end