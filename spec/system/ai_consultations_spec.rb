require 'rails_helper'

RSpec.describe "Ai_consultations", type: :system do
  let(:user) { create(:user) }
  before do
    login(user)
  end
  describe "AI相談フォーム" do
    it "フォームが表示される" do
      visit new_ai_consultation_path
      expect(page).to have_content "愛犬のどんなことに悩んでいますか？"
      expect(page).to have_button "相談する"
    end
    context "初回相談" do
      before do
        mock_response = {
          "summary" => "犬が散歩中に吠える悩みです。",
          "empathy" => "とても頑張っていますね🐶少しずつ練習していきましょう！",
          "advice" => {
            "short_term" => [ "吠えそうになったら距離をとる", "落ち着いたらほめる", "短い散歩から始める" ],
            "long_term" => [ "社会化トレーニングを行う", "ポジティブ強化を続ける" ]
          },
          "cheer" => "あなたの努力はきっと伝わります✨"
        }
        allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(
          { "choices" => [ { "message" => { "content" => mock_response.to_json } } ] }
        )
      end
      it "必要項目を入力して送信するとAIの回答が表示される", js: true do
        visit new_ai_consultation_path
        fill_in "愛犬のどんなことに悩んでいますか？", with: "散歩中に吠える"
        fill_in "いつ起こりますか？", with: "他の犬とすれ違うとき"
        fill_in "愛犬の様子はどうですか？", with: "吠えて引っ張る"
        fill_in "愛犬にどうなってほしいですか？一緒に何がしたいですか？", with: "落ち着いて散歩を楽しみたい"
        click_button "相談する"
        expect(page).to have_content("犬が散歩中に吠える悩みです。")
        expect(page).to have_content("とても頑張っていますね🐶")
        expect(page).to have_content("あなたの努力はきっと伝わります✨")
        consultation = AiConsultation.last
        expect(page).to have_selector("form[action='#{followup_ai_consultation_path(consultation)}']")
        expect(page).to have_field("追加で聞きたいことを入力…")
      end
    end
    context "異常系" do
      it "全て空だとエラーメッセージが表示される", js: true do
        visit new_ai_consultation_path
        click_button "相談する"
        expect(page).to have_content("少なくとも1つの項目を入力してください")
      end
    end
  end
  describe "履歴からの相談" do
    let!(:consultation) { create(:ai_consultation, user: user) }
    it "過去の相談履歴が表示され、選択して再表示できる" do
      visit new_ai_consultation_path
      visit ai_consultations_path
      expect(page).to have_content(consultation.title)
      find("span.font-medium", text: consultation.title).find(:xpath, "./ancestor::a").click
      expect(page).to have_content "「TOMONIくん」の回答"
    end
  end

  describe "追加質問フォーム", js: true do
    let!(:consultation) { create(:ai_consultation, user: user) }
    it "AI回答の下に追加質問フォームから質問ができる" do
      allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return({
        "choices" => [
          { "message" => { "content" => "フォローアップの回答です。" } }
        ]
      })
      visit ai_consultation_path(consultation)
      fill_in "追加で聞きたいことを入力…", with: "他の犬と仲良くなる練習はどうする？"
      click_on "送信"
      expect(page).to have_content("他の犬と仲良くなる練習はどうする？", wait: 10)
      expect(page).to have_content("フォローアップの回答です。", wait: 10)
    end
  end
end
