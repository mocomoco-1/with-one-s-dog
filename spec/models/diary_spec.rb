require 'rails_helper'

RSpec.describe Diary, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { create(:user) }
  let(:diary) { build(:diary, user: user) }

  describe "バリデーション" do
    it "有効な内容であれば保存できる" do
      expect(diary).to be_valid
    end
    it "日記が空の場合は無効" do
      diary.content = ""
      expect(diary).not_to be_valid
      expect(diary.errors[:content]).to include("を入力してください")
    end
    it "日記が65535文字以内であれば有効" do
      diary.content = "a" * 65_535
      expect(diary).to be_valid
    end
    it "日記が65535文字以上だと無効" do
      diary.content = "a" * 65_536
      expect(diary).not_to be_valid
    end
    it "日付が空の場合無効" do
      diary.written_on = nil
      expect(diary).not_to be_valid
    end
    it "同一ユーザーで日付が重複すると無効" do
      create(:diary, user: user, written_on: Date.today)
      duplicate = build(:diary, user: user, written_on: Date.today)
      expect(duplicate).not_to be_valid
    end
    it "別ユーザーであれば同じ日付でも有効" do
      create(:diary, user: user, written_on: Date.today)
      other_user = create(:user)
      diary = build(:diary, user: other_user, written_on: Date.today)
      expect(diary).to be_valid
    end
  end
  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should have_many(:reactions).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many_attached(:images) }
  end

  describe "enum" do
    it "statusにprivateとpublishedが定義されている" do
      expect(Diary.statuses.keys).to include("private", "published")
    end
    it "status_private?メソッドが使える" do
      diary.status = :private
      expect(diary.status_private?).to be true
    end
  end
end
