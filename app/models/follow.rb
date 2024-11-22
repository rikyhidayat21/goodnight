class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: {
    scope: :followed_id,
    message: "unable to follow the same user"
  }
  validate :not_self_follow

  private

  def not_self_follow
    errors.add(:base, "unable to follow themselves") if follower_id == followed_id
  end
end
