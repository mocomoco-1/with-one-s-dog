require "rails_helper"

RSpec.describe "ChatMessages", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:chat_room) { create(:chat_room) }

  before do
    chat_room.chat_room_users.create!(user: user)
    chat_room.chat_room_users.create!(user: other_user)
    sign_in user
  end

  describe "POST /chat_rooms/:chat_room_id/chat_messages" do
    it "メッセージを保存できる" do
      expect {
        post chat_room_chat_messages_path(chat_room), params: { chat_message: { content: "こんにちは" } }
      }.to change(ChatMessage, :count).by(1)
    end

    it "空メッセージは保存できない" do
      expect {
        post chat_room_chat_messages_path(chat_room), params: { chat_message: { content: "" } }
      }.not_to change(ChatMessage, :count)
    end
    it "画像だけのメッセージも保存できる" do
      file = fixture_file_upload(Rails.root.join("spec/fixtures/test_image.png"), "image/png")
      expect {
        post chat_room_chat_messages_path(chat_room), params: { chat_message: { images: [file] } }
      }.to change(ChatMessage, :count).by(1)
    end
    it "メッセージと画像の両方を送信できる" do
      file = fixture_file_upload(Rails.root.join("spec/fixtures/test_image.png"), "image/png")
      expect {
        post chat_room_chat_messages_path(chat_room), params: { chat_message: { content: "こんにちは", images: [file] } }
      }.to change(ChatMessage, :count).by(1)
    end
  end
end
