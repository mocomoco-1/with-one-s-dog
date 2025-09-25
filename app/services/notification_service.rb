class NotificationService
  def self.create(sender:, recipient:, notifiable:)
    return if sender == recipient
    Notification.create!(
      sender: sender,
      recipient: recipient,
      notifiable: notifiable
    )
  end

  def self.message(notifiable, sender)
    case notifiable
    when ChatMessage
      "#{sender.name}さんから新しいメッセージがあります"
    when Relationship
      "#{sender.name}さんからフォローされました"
    when Comment
      "#{sender.name}さんからコメントがあります"
    when Reaction
      "#{sender.name}さんが投稿にリアクションしました"
    when Like
      "#{sender.name}さんがコメントにいいねしました"
    else
      "#{sender.name}さんから通知があります"
    end
  end
end
