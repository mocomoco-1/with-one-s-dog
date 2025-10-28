require "rails_helper"

RSpec.describe Diagnosis, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe ".diagnose" do
    let!(:question1) { create(:question) }
    let!(:question5) { create(:question) }
    let!(:choice1) { create(:choice, question: question1) }
    let!(:choice2) { create(:choice, question: question1) }
    let!(:choice5) { create(:choice, question: question5) }
    let!(:diagnosis1) { create(:diagnosis, title: "結果1") }
    let!(:diagnosis2) { create(:diagnosis, title: "結果2") }

    before do
      create(:choices_diagnosis, choice: choice1, diagnosis: diagnosis1)
      create(:choices_diagnosis, choice: choice2, diagnosis: diagnosis2)
      create(:choices_diagnosis, choice: choice5, diagnosis: diagnosis1)
    end
    context "基本的なロジック" do
      it "有効な選択肢IDで診断結果を返すこと" do
        selected_choice_ids = [ choice1.id, choice5.id ]
        diagnosis = Diagnosis.diagnose(selected_choice_ids)
        expect(diagnosis).to eq(diagnosis1)
      end

      context "質問5の重みづけ" do
        it "質問５の選択肢に２倍の重みが適応されること" do
          selected_choice_ids = [ choice2.id, choice5.id ]
          diagnosis = Diagnosis.diagnose(selected_choice_ids)
          expect(diagnosis).to eq(diagnosis1)
        end
      end

      context "異常系のテスト" do
        it "存在しない選択肢が含まれている場合、nilを返すこと" do
          non_existent_id = 99999
          selected_choice_ids = [choice1.id, non_existent_id]
          diagnosis = Diagnosis.diagnose(selected_choice_ids)
          expect(diagnosis).to be_nil
        end

        it "空の配列が渡された場合、nilを返すこと" do
          diagnosis = Diagnosis.diagnose([])
          expect(diagnosis).to be_nil
        end

        it "nilが渡されたとき、nilを返すこと" do
          diagnosis = Diagnosis.diagnose(nil)
          expect(diagnosis).to be_nil
        end
      end
    end
    context "アソシエーション" do
      it "choices_diagnosisとの関連が正しく設定されていること" do
        expect(diagnosis1.choices_diagnoses).to be_present
      end
      it "choicesとの関連が正しく設定されていること" do
        expect(diagnosis1.choices).to include(choice1)
      end
    end
  end
  describe "バリデーション" do
    it "diagnosisが存在すること" do
      diagnosis = build(:diagnosis, title: nil)
      expect(diagnosis).not_to be_valid
    end

    it "explanationが存在すること" do
      diagnosis = build(:diagnosis, explanation: nil)
      expect(diagnosis).not_to be_valid
    end

    it "dog_messageが存在すること" do
      diagnosis = build(:diagnosis, dog_message: nil)
      expect(diagnosis).not_to be_valid
    end
  end
end
