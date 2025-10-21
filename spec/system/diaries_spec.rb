require 'rails_helper'

RSpec.describe "Diaries", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:published_diary) { create(:diary, user: other_user, written_on: Date.today - 2, status: :published, content: "公開日記") }
  let!(:private_diary) { create(:diary, user: other_user, written_on: Date.today - 3, status: :private, content: "非公開日記") }
  let!(:my_diary) { create(:diary, user: user, written_on: Date.today - 1, status: :private, content: "私の日記") }

  before do
    login(user)
  end
  describe "日記一覧" do
    it "公開日記のみ表示される" do
      visit diaries_path
      expect(page).to have_content "公開日記"
      expect(page).not_to have_content "非公開日記"
    end
  end
  describe "うちの子日記一覧" do
    it "自分の日記のみ表示される" do
      visit my_diaries_diaries_path
      expect(page).to have_content "私の日記"
      expect(page).not_to have_content "公開日記"
    end
  end
  describe "日記作成" do
    it "日記を投稿できる" do
      visit diaries_path
      click_link "うちの子日記を書く"
      fill_in "日付", with: Date.today
      fill_in "日記", with: "今日は寒いです"
      choose "公開"
      click_button "投稿する"
      expect(page).to have_content "今日は寒いです"
    end
    it "同じ日付は投稿できない" do
      create(:diary, user: user, written_on: Date.today)
      visit diaries_path
      click_link "うちの子日記を書く"
      fill_in "日付", with: Date.today
      fill_in "日記", with: "重複日付"
      choose "公開"
      click_button "投稿する"
      expect(page).to have_content "日付はすでに存在します"
    end
  end
  describe "投稿編集、削除" do
    it "自分の日記は編集できる" do
      visit diary_path(my_diary)
      expect(page).to have_content "編集"
      click_link "編集"
      fill_in "日記", with: "編集済み日記"
      click_button "投稿する"
      expect(page).to have_content "編集済み日記"
    end
    it "投稿者は削除できる" do
      visit diary_path(my_diary)
      expect(page).to have_content "削除"
      accept_confirm do
      click_link "削除"
      end
      expect(page).to have_content "日記を削除しました"
      expect(Diary.exists?(my_diary.id)).to be_falsey
    end
    it "他人の投稿は編集・削除が表示されない" do
      visit diary_path(published_diary)
      expect(page).not_to have_link "編集"
      expect(page).not_to have_link "削除"
    end
  end
  describe "コメント機能" do
    it "コメントが投稿できる", js: true do
      visit diary_path(published_diary)
      fill_in "コメント", with: "日記コメント"
      click_button "投稿"
      expect(page).to have_text "日記コメント", wait: 5
    end
    it "空コメントは投稿できない" do
      visit diary_path(published_diary)
      fill_in "コメント", with: ""
      click_button "投稿"
      expect(page).to have_text "コメントを入力してください", wait: 5
    end
  end
  describe "リアクション機能", js: true do
    it "リアクションを押すとカウントが１増え,同じリアクションを押すと解除される", js: true do
      visit diary_path(published_diary)
      reaction_count_selector = "#reaction-count-#{published_diary.id}-cheer"
      expect(page).not_to have_selector(reaction_count_selector, text: "1")
      click_button "応援"
      expect(page).to have_selector(reaction_count_selector, text: "1")
      click_button "応援"
      expect(page).not_to have_selector(reaction_count_selector, text: "1", wait: 5)
    end
  end
end
