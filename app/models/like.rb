class Like < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :user_id, uniqueness: { scope: :comment_id }
  after_create :notify_like_owner

  private

  def notify_like_owner
    recipient = comment.user
    return if recipient == user
    NotificationService.create(sender: user, recipient: comment.user, notifiable: self)
  end
end
