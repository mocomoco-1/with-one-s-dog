class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User", optional: true
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(unread: true) }

  def redirect_path
    case notifiable
    when ChatMessage
      Rails.application.routes.url_helpers.chat_room_path(notifiable.chat_room)
    when Relationship
      Rails.application.routes.url_helpers.followers_user_path(notifiable.followed)
    when Reaction
      Rails.application.routes.url_helpers.polymorphic_path(notifiable.reactable)
    when Comment
      Rails.application.routes.url_helpers.polymorphic_path(notifiable.commentable)
    when Like
      Rails.application.routes.url_helpers.polymorphic_path(notifiable.comment.commentable)
    else
      Rails.application.routes.url_helpers.polymorphic_path(notifiable)
    end
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
