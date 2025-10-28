require "rails_helper"

RSpec.describe "Chat", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:chat_room) { create(:chat_room, users: [ user, other_user ]) }

  before do
    login(user)
  end
  describe "正常系" do
    it "メッセージを送信できる", js: true do
      visit chat_room_path(chat_room)
      expect(page).to have_field('メッセージを入力', wait: 5)
      save_and_open_screenshot
      find('textarea[placeholder="メッセージを入力"]').set('こんにちは')
      click_on "送信"
      save_and_open_screenshot
      expect(page).to have_css(".message-bubble", text: "こんにちは", wait: 5)
    end
  end
  describe "異常系" do
    it "空のメッセージは送信できない" do
      visit chat_room_path(chat_room)
      click_on "送信"
      expect(page).not_to have_selector(".message")
    end
  end
end
