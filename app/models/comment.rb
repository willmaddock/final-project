class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :profile

  acts_as_votable  # Enables voting (e.g., upvotes) on comments

  # Validation for comment body
  validates :body, presence: true, length: { maximum: 1000 }

  # You can add additional helper methods to make it easier to access upvotes
  def upvote_count
    # This will return the number of upvotes for the comment
    self.votes_for.size
  end
end