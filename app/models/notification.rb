class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User", optional: true
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(unread: true) }

  after_create_commit { NotificationBroadcastJob.perform_later(self) }

  def redirect_path
    Rails.logger.info "Notification #{id} notifiable: #{notifiable.inspect}"
    case notifiable
    when ChatMessage
      return nil if notifiable.blank? || notifiable.chat_room.blank?
      Rails.application.routes.url_helpers.chat_room_path(notifiable.chat_room)
    when Relationship
      return nil if notifiable.blank? || notifiable.followed.blank?
      Rails.application.routes.url_helpers.followers_user_path(notifiable.followed)
    when Reaction
      return nil if notifiable.blank? || notifiable.reactable.blank?
      Rails.application.routes.url_helpers.polymorphic_path(notifiable.reactable)
    when Comment
      return nil if notifiable.blank? || notifiable.commentable.blank?
      Rails.application.routes.url_helpers.polymorphic_path(notifiable.commentable)
    when Like
      return nil if notifiable.blank? || notifiable.comment.blank? || notifiable.comment.commentable.blank?
      Rails.application.routes.url_helpers.polymorphic_path(notifiable.comment.commentable)
    else
      Rails.application.routes.url_helpers.root_path
    end
  rescue => e
    # エラーが発生した場合はルートパスにリダイレクト
    Rails.logger.error "Error generating redirect_path for notification #{id}: #{e.message}"
    Rails.application.routes.url_helpers.root_path
  end

  def redirect_path_with_notification_id
    base_path = redirect_path
    return nil unless base_path
    if base_path.include?("?")
      "#{base_path}&notification_id=#{id}"
    else
      "#{base_path}?notification_id=#{id}"
    end
  end
end
