require 'rails_helper'

RSpec.describe "Consultations", type: :system do
  let(:user) { create(:user) }
  let!(:consultation) { create(:consultation, title: "吠え", content: "他犬によく吠えます") }

  context "未ログインユーザー" do
    it "お悩み相談一覧・詳細ページは閲覧可能" do
      visit consultations_path
      expect(page).to have_content consultation.title
      expect(page).to have_content consultation.content.truncate(80)
      visit consultation_path(consultation)
      expect(page).to have_content consultation.content
    end
    it "投稿ボタン、コメント欄に「ログインか新規登録が必要です」と表示される" do
      visit consultations_path
      expect(page).to have_content "お悩み相談するにはログインか新規登録が必要です"
      visit consultation_path(consultation)
      expect(page).to have_content "コメントするにはログインか新規登録が必要です"
    end
    it "投稿ページにアクセスするとログインページにリダイレクトされる" do
      visit consultations_path
      click_link "お悩み相談する"
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content "ログインもしくはアカウント登録してください。"
    end
  end
  context "ログインユーザー" do
    before do
      login(user)
    end
    it "お悩み相談を投稿できる" do
      visit consultations_path
      click_link "お悩み相談する"
      fill_in "タイトル", with: "散歩で歩いてくれない"
      fill_in "本文", with: "毎日朝は歩いてくれません。"
      click_button "投稿する"
      expect(page).to have_content "お悩み相談を作成しました"
      expect(page).to have_content "散歩で歩いてくれない"
      expect(page).to have_content "毎日朝は歩いてくれません。"
    end
    it "タイトルが入力されていないとエラーになる" do
      visit new_consultation_path
      fill_in "タイトル", with: ""
      fill_in "本文", with: "毎日朝は歩いてくれません。"
      click_button "投稿する"
      expect(page).to have_content "タイトルを入力してください"
    end
    it "コメントが投稿できる", js: true do
      visit consultation_path(consultation)
      fill_in "コメント", with: "大変ですね"
      click_button "投稿"
      expect(page).to have_content "大変ですね"
    end
    it "リアクションを押すとカウントが１増える", js: true do
      visit consultation_path(consultation)
      reaction_count_selector = "#reaction-count-#{consultation.id}-cheer"
      expect(page).not_to have_selector(reaction_count_selector, text: "1")
      click_button "応援"
      expect(page).to have_selector(reaction_count_selector, text: "1")
    end
  end
end
