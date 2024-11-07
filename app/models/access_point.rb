class AccessPoint < ApplicationRecord
  validates :location, presence: true
  validates :access_level, presence: true
  validates :description, presence: true
  validates :status, inclusion: { in: [true, false] }
end