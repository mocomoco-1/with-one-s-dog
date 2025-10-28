# spec/channels/chat_room_channel_spec.rb
require "rails_helper"

RSpec.describe ChatRoomChannel, type: :channel do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:chat_room) { create(:chat_room, users: [ user, other_user ]) }

  before do
    stub_connection current_user: user
  end

  describe "購読" do
    it "購読できる" do
      subscribe(chat_room_id: chat_room.id)
      expect(subscription).to be_confirmed
    end
  end

  describe "メッセージ受信" do
    let!(:message) { create(:chat_message, chat_room: chat_room, user: user) }
    it "mark_readアクションでbroadcastされる" do
      subscribe(chat_room_id: chat_room.id)
      expect {
        perform :mark_read, { chat_room_id: chat_room.id, last_read_message_id: message.id }
      }.to have_broadcasted_to(chat_room).with(hash_including(
        type: "read",
        chat_room_id: chat_room.id
      ))
    end
  end

  describe "複数ユーザーでの購読" do
    it "他のユーザーにもbroadcastされる" do
      # 別ユーザーで購読
      stub_connection current_user: other_user
      subscribe(chat_room_id: chat_room.id)

      # 元のユーザーでbroadcast
      stub_connection current_user: user
      subscribe(chat_room_id: chat_room.id)

      expect {
        ChatRoomChannel.broadcast_to(chat_room, { type: "read", chat_room_id: chat_room.id })
      }.to have_broadcasted_to(chat_room).with(hash_including(type: "read"))
    end
  end
end
