class AccessLog < ApplicationRecord
  belongs_to :user
  belongs_to :access_point

  # Validations to ensure the presence of essential fields
  validates :user_id, presence: true
  validates :access_point_id, presence: true
  validates :timestamp, presence: true
  validates :successful, inclusion: { in: [true, false] }  # Optional but good practice

  # Callback to set the timestamp automatically before creating a record
  before_create :set_timestamp

  private

  def set_timestamp
    self.timestamp = Time.current
  end

  # Optional: Method to format the timestamp for display
  def formatted_timestamp
    timestamp.strftime("%B %d, %Y at %I:%M %p") if timestamp
  end
end