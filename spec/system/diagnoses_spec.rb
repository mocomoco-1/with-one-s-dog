require "rails_helper"
RSpec.describe "Diagnoses", type: :system do
  describe "診断トップページ" do
    it "診断トップページが正しく表示される" do
      visit dog_diagnosis_diagnoses_index_path
      expect(page).to have_content "いぬのきもち診断"
      expect(page).to have_link "診断を始める"
    end
  end
  describe "診断実行", js: true do
    before do
      visit dog_diagnosis_diagnoses_index_path
      click_link "診断を始める"
      visit dog_diagnosis_questions_path
      expect(page).to have_content "わんこ、今どこで何してる？"
      choose "ひざの上でぬくぬく…「ここがいちばん安心する」"
      click_button "次の問題へ→"
      expect(page).to have_content "ごはんを出すと、どんな顔をする？"
      choose "そっと近づいてお座り。「おりこうさんだからください！」"
      click_button "次の問題へ→"
      expect(page).to have_content "お散歩の気配を感じたときは？"
      choose "「今日はもう終わったよ！（頭の中で）」"
      click_button "次の問題へ→"
      expect(page).to have_content "飼い主と目が合った時のリアクションは？"
      choose "ごろんと「動く気力はありません」"
      click_button "次の問題へ→"
      expect(page).to have_content "しっぽ、今どんな感じ？"
      choose "ゆっくりふりふり「かいぬし見ているだけで幸せ」"
      click_button "診断結果を見る🐶"
    end
    it "診断結果が表示される" do
      expect(page).to have_content "診断結果"
    end
    it "もう一度診断するボタンで診断トップに戻ることができる" do
      click_link "もう一度診断する"
      expect(page).to have_content "いぬのきもち診断"
    end
    context "ログインしていない場合" do
      it "日記に投稿ボタンでログイン画面に遷移する" do
        click_link "診断結果を日記に投稿する"
        expect(page).to have_current_path new_user_session_path
      end
    end
  end
  context "ログインしている場合" do
    let!(:user) { create(:user) }
    before do
      login(user)
      visit dog_diagnosis_diagnoses_index_path
      click_link "診断を始める"
      visit dog_diagnosis_questions_path
      expect(page).to have_current_path(dog_diagnosis_questions_path)
      expect(page).to have_content "わんこ、今どこで何してる？"
      choose "ひざの上でぬくぬく…「ここがいちばん安心する」"
      click_button "次の問題へ→"
      expect(page).to have_content "ごはんを出すと、どんな顔をする？"
      choose "そっと近づいてお座り。「おりこうさんだからください！」"
      click_button "次の問題へ→"
      expect(page).to have_content "お散歩の気配を感じたときは？", wait: 10
      choose "「今日はもう終わったよ！（頭の中で）」"
      click_button "次の問題へ→"
      expect(page).to have_content "飼い主と目が合った時のリアクションは？", wait: 10
      choose "ごろんと「動く気力はありません」"
      click_button "次の問題へ→"
      expect(page).to have_content "しっぽ、今どんな感じ？", wait: 10
      choose "ゆっくりふりふり「かいぬし見ているだけで幸せ」"
      click_button "診断結果を見る🐶"
    end
    it "日記に投稿ボタンで日記作成ページに遷移する", js: true do
      click_link "診断結果を日記に投稿する"
      expect(page).to have_current_path new_diary_path
      expect(page).to have_content "今日のうちの子のきもち診断は"
    end
  end
  describe "エラーケース" do
    it "選択肢を選ばずに次へ進もうとするとエラーが発生する" do
      visit dog_diagnosis_diagnoses_index_path
      click_link "診断を始める"
      visit dog_diagnosis_questions_path
      click_button "次の問題へ→"
      expect(page).to have_content "選択肢を選んでください🐕"
    end
  end
end
