require 'rails_helper'

RSpec.describe Consultation, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { create(:user) }
  describe "バリデーション" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(65_535) }
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:reactions).dependent(:destroy) }
  end

  describe "タグ付け機能" do
    it "タグを追加できる" do
      consultation = create(:consultation, user: user)
      consultation.tag_list.add("犬", "散歩")
      consultation.save
      expect(consultation.tag_list).to include("犬", "散歩")
    end
    it "タグを削除できる" do
      consultation = create(:consultation, user: user, tag_list: [ "犬", "散歩" ])
      consultation.tag_list.remove("犬")
      consultation.save
      expect(consultation.tag_list).not_to include("犬")
      expect(consultation.tag_list).to include("散歩")
    end
  end
  describe "検索機能" do
    before do
      @c1 = create(:consultation, user: user, title: "散歩で歩かない", content: "おやつトレーニング")
      @c2 = create(:consultation, user: user, title: "偏食", content: "ドライフード食べない")
    end
    it "タイトル検索できること" do
      results = Consultation.search_similar("散歩")
      expect(results).to include(@c1)
      expect(results).not_to include(@c2)
    end
    it "本文検索できること" do
      results = Consultation.search_similar("ドライフード")
      expect(results).to include(@c2)
      expect(results).not_to include(@c1)
    end
  end
end
