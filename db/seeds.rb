# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "faker"
10.times do
  User.find_or_create_by!(email: Faker::Internet.unique.email) do |user|
              user.name = Faker::Name.name
              user.password = "password"
              user.password_confirmation = "password"
  end
end

user_ids = User.ids

10.times do |index|
  user = User.find(user_ids.sample)
  user.consultations.create!(title: "タイトル#{index}", content: "本文#{index}")
end

5.times do |i|
  room = ChatRoom.create!(name: "testroom#{ i + 1 }")
  participants = [ 1 ] + user_ids.sample(rand(1..3))
  participants.each do |user_id|
    ChatRoomUser.create!(chat_room: room, user_id: user_id)
  end

  10.times do
    ChatMessage.create!(
      chat_room: room,
      user_id: participants.sample,
      content: Faker::Lorem.sentence(word_count: 5)
    )
  end
end
