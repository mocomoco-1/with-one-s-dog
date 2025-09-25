module NotificationsHelper
  def notification_path_for(notifiable)
    case notifiable
    when ChatMessage
      chat_room_path(notifiable.chat_room)
    when Relationship
      followers_user_path(notifiable.followed)
    when Reaction
      polymorphic_path(notifiable.reactable)
    when Comment
      polymorphic_path(notifiable.commentable)
    when Like
      polymorphic_path(notifiable.comment.commentable)
    else
      polymorphic_path(notifiable)
    end
  end
end
