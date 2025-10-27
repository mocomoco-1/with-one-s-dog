require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:chat_room) { create(:chat_room) }

  before do
    create(:chat_room_user, chat_room: chat_room, user: user1)
    create(:chat_room_user, chat_room: chat_room, user: user2)
  end

  describe "バリデーション" do
    context "content imagesが両方からの場合" do
      it "メッセージは送信できない" do
        chat_message = build(:chat_message, content: nil)
        chat_message.images.detach
        expect(chat_message.save).to be_falsey
      end
    end
    context "contentがある場合" do
      it "メッセージは送信できる" do
        chat_message = build(:chat_message, content: "犬です")
        chat_message.images.detach
        expect(chat_message.valid?).to be_truthy
      end
    end
    context "imagesがある場合" do
      it "メッセージは送信できる" do
        chat_message = build(:chat_message, content: nil)
        chat_message.images.attach(
          io: StringIO.new("fake image data"),
          filename: "test.png",
          content_type: "image/png"
        )
        expect(chat_message.valid?).to be_truthy
      end
    end
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:chat_room) }
    it { should have_many(:notifications).dependent(:destroy) }
  end

  describe "#read_by?" do
    let!(:message1) { create(:chat_message, chat_room: chat_room, user: user1) }
    let!(:message2) { create(:chat_message, chat_room: chat_room, user: user1) }
    let!(:chat_room_user) { chat_room.chat_room_users.find_by(user: user2) }
    context "ユーザーがlast_read_message_idを持たない場合" do
      it "未読のためfalseを返す" do
        expect(message1.read_by?(user2)).to be false
      end
    end
    context "ユーザーがlast_read_message_idを持つ場合" do
      it "既読メッセージならtrueを返す" do
        chat_room_user.update(last_read_message_id: message2.id)
        expect(message1.read_by?(user2)).to be true
      end
      it "未読メッセージならfalseを返す" do
        chat_room_user.update(last_read_message_id: message1.id)
        expect(message2.read_by?(user2)).to be false
      end
    end
  end
  describe "コールバック" do
    it "作成時にChatMessageBroadcastJobが実行される" do
      expect {
        create(:chat_message, chat_room: chat_room, user: user1, content: "テスト")
      }.to have_enqueued_job(ChatMessageBroadcastJob)
    end
    it "notify_chat_room_usersで通知が作成される" do
      allow(NotificationService).to receive(:create)
      create(:chat_message, chat_room: chat_room, user: user1, content: "通知テスト")
      expect(NotificationService).to have_received(:create).with(
        sender: user1,
        recipient: user2,
        notifiable: instance_of(ChatMessage)
      )
    end
  end
end
