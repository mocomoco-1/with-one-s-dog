class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id }
  after_create :notify_relationship

  private

  def notify_relationship
    NotificationService.create(sender: follower, recipient: followed, notifiable: self)
  end
end
