class AccessLog < ApplicationRecord
  belongs_to :user
  belongs_to :access_point
end
