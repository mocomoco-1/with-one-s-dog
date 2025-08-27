# --- ユーザー作成 ---
users_data = [
  { name: "ポメラニアンてすと", email: "test1@example.com" },
  { name: "柴犬てすと", email: "test2@example.com" },
  { name: "ブルてすと", email: "test3@example.com" }
]

users = users_data.map do |data|
  User.find_or_create_by!(email: data[:email]) do |user|
    user.name = data[:name]
    user.password = "password"
    user.password_confirmation = "password"
  end
end

user_ids = users.map(&:id)

# --- 相談作成 ---
10.times do |index|
  user = User.find(user_ids.sample)
  # 同じタイトルの相談があれば作らない
  Consultation.find_or_create_by!(title: "タイトル#{index}", user: user) do |consultation|
    consultation.content = "本文#{index}"
  end
end

# --- 1対1チャット作成 ---
user_ids.combination(2).each_with_index do |(user1_id, user2_id), i|
  break if i >= 5 # 最大5部屋

  room = ChatRoom.find_or_create_by!(name: "chatroom#{i + 1}")

  [user1_id, user2_id].each do |uid|
    ChatRoomUser.find_or_create_by!(chat_room: room, user_id: uid)
  end

  10.times do |j|
    ChatMessage.find_or_create_by!(
      chat_room: room,
      user_id: [user1_id, user2_id].sample,
      content: "固定メッセージ#{i}-#{j}"
    )
  end
end
