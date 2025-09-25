class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :likes, dependent: :destroy

  validates :content, presence: true, length: { maximum: 65_535 }
  after_create :notify_comment_owner

  private

  def notify_comment_owner
    NotificationService.create(sender: user, recipient: commentable.user, notifiable: self)
  end
end
