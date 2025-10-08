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
    when DogProfile
      if notifiable.birthday_today?
        "今日は#{notifiable.name}の誕生日です🎂おめでとう🐶🎊今年も幸せであふれた一年になりますように💓"
      elsif notifiable.anniversary_today?
        "今日は#{notifiable.name}のうちの子記念日です🐾うちの子になってくれてありがとう🐶🎊今年も幸せであふれた一年になりますように💓"
      end
    else
      "#{sender.name}さんから通知があります"
    end
  end
end
