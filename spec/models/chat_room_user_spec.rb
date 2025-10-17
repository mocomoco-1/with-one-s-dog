require 'rails_helper'

RSpec.describe ChatRoomUser, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:chat_room) }
    it { should belong_to(:last_read_message).class_name("ChatMessage").optional }
  end

  describe "#unread_count" do
    let(:chat_room) { create(:chat_room) }
    let(:user_current) { create(:user) }
    let(:user_other) { create(:user) }
    let(:chat_room_user) { create(:chat_room_user, user: user_current, chat_room: chat_room) }
    context "last_read_messageがない場合" do
      it "自分以外のメッセージを全て未読カウントする" do
        create(:chat_message, chat_room: chat_room, user: user_other)
        create(:chat_message, chat_room: chat_room, user: user_current)
        expect(chat_room_user.unread_count).to eq(1)
      end
    end
    context "last_read_messageがある場合" do
      it "最後に読んだIDより大きく、かつ自分以外のメッセージをカウントする" do
        old_message = create(:chat_message, chat_room: chat_room, user: user_other)
        read_message = create(:chat_message, chat_room: chat_room, user: user_other)
        new_message = create(:chat_message, chat_room: chat_room, user: user_other)
        chat_room_user.update(last_read_message: read_message)
        expect(chat_room_user.unread_count).to eq(1)
      end
    end
  end
end
