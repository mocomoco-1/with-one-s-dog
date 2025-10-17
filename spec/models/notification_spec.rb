require 'rails_helper'

RSpec.describe Notification, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "アソシエーション" do
    it { should belong_to(:sender).class_name("User").optional }
    it { should belong_to(:recipient).class_name("User") }
    it { should belong_to(:notifiable) }
  end
  describe "スコープ" do
    it "未読スコープ" do
      read = create(:notification, unread: false)
      unread = create(:notification, unread: true)
      expect(Notification.unread).to include(unread)
      expect(Notification.unread).not_to include(read)
    end
  end

  describe "#redirect_path" do
    let(:sender) { create(:user) }
    let(:recipient) { create(:user) }
    context "チャットメッセージの通知の場合" do
      let(:chat_room) { create(:chat_room) }
      let(:message) { create(:chat_message, chat_room: chat_room) }
      let(:notification) { create(:notification, sender: sender, recipient: recipient, notifiable: message) }
      it "正しいパスを返すか" do
        expect(notification.redirect_path).to eq(Rails.application.routes.url_helpers.chat_room_path(chat_room))
      end
    end
  end
end
