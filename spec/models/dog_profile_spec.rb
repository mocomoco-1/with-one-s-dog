require 'rails_helper'

RSpec.describe DogProfile, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { create(:user) }
  let(:dog_profile) { build(:dog_profile, user: user) }

  describe "バリデーション" do
    it { should belong_to(:user) }
    it "名前が必須である" do
      dog_profile.name = nil
      expect(dog_profile).not_to be_valid
      expect(dog_profile.errors[:name]).to include("を入力してください")
    end
    it "誕生日と年齢両方入力されていると無効である" do
      dog_profile.birthday = Date.new(2020, 6, 6)
      dog_profile.age = 4
      dog_profile.valid?
      expect(dog_profile.errors[:age]).to include("誕生日が入力されている場合、年齢は手入力できません")
    end
  end

  describe "#display_age" do
    context "誕生日がある場合" do
      it "年齢を「〇歳〇か月」で返す" do
        dog_profile.birthday = Date.today << (12 * 3 + 2)
        expect(dog_profile.display_age).to eq("3歳2か月")
      end
    end
    context "誕生日がなく年齢がある場合" do
      it "推定年齢を返す" do
        dog_profile.birthday = nil
        dog_profile.age = 5
        expect(dog_profile.display_age).to eq("5歳 (推定)")
      end
    end
    context "誕生日も年齢もない場合" do
      it "年齢不明を返す" do
        dog_profile.birthday = nil
        dog_profile.age = nil
        expect(dog_profile.display_age).to eq("年齢不明")
      end
    end
  end
  describe "#birthday_today?" do
    it "誕生日が今日ならtrueを返す" do
      dog_profile.birthday = Date.today
      expect(dog_profile.birthday_today?).to be true
    end
    it "誕生日が今日でなければfalseを返す" do
      dog_profile.birthday = Date.today - 1
      expect(dog_profile.birthday_today?).to be false
    end
  end

  describe "#anniversary_today?" do
    it "うちの子記念日が今日ならtrueを返す" do
      dog_profile.comehome_date = Date.today
      expect(dog_profile.anniversary_today?).to be true
    end
    it "うちの子記念日が今日でないならfalseを返す" do
      dog_profile.comehome_date = Date.today - 1
      expect(dog_profile.anniversary_today?).to be false
    end
  end
end
