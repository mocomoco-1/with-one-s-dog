require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let!(:user1) { create(:user, name: "Alice") }
  let!(:user2) { create(:user, name: "Bob") }
  let!(:chat_room) { create(:chat_room, users: [ user1, user2 ]) }
  describe "アソシエーション" do
    it { should have_many(:chat_room_users).dependent(:destroy) }
    it { should have_many(:users).through(:chat_room_users) }
    it { should have_many(:chat_messages).dependent(:destroy) }
  end

  describe "#display_name" do
    it "自分以外の名前を返す" do
      expect(chat_room.display_name(user1)).to eq("Bob")
      expect(chat_room.display_name(user2)).to eq("Alice")
    end
    it "相手が存在しない場合はUnknown Userを返す" do
      solo_room = create(:chat_room, users: [ user1 ])
      expect(solo_room.display_name(user1)).to eq("Unknown User")
    end
  end
  describe "#other_user" do
    it "自分以外のユーザーを返す" do
      expect(chat_room.other_user(user1)).to eq(user2)
      expect(chat_room.other_user(user2)).to eq(user1)
    end
  end
  describe "#latest_message" do
    it "最新メッセージを返す" do
      old_message = create(:chat_message, chat_room: chat_room, user: user1, content: "hello", created_at: 1.hour.ago)
      new_message = create(:chat_message, chat_room: chat_room, user: user2, content: "hi", created_at: Time.current)
      expect(chat_room.latest_message).to eq(new_message)
    end
  end
  describe "#unread_count_for" do
    it "ChatRoomUser#unread_countを呼び出して値を返す" do
      message1 = create(:chat_message, chat_room: chat_room, user: user1)
      message2 = create(:chat_message, chat_room: chat_room, user: user1)
      chat_room_user = chat_room.chat_room_users.find_by(user_id: user2.id)
      chat_room_user.update(last_read_message_id: message1.id)
      expect(chat_room.unread_count_for(user2)).to eq(1)
    end

    it "chat_room_userがいない場合は0を返す" do
      new_user = create(:user)
      expect(chat_room.unread_count_for(new_user)).to eq(0)
    end
  end
end
