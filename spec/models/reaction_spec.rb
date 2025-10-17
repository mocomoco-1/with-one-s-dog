require 'rails_helper'

RSpec.describe Reaction, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:reactable) }
  end

  describe "バリデーション" do
    it "reaction_categoryがなければ無効である" do
      reaction = build(:reaction, reaction_category: nil, reactable: create(:diary))
      expect(reaction).not_to be_valid
    end
    it "同じユーザーは同じreactableに同じリアクションを複数つけることはできない" do
      diary = create(:diary)
      user = create(:user)
      create(:reaction, user: user, reactable: diary, reaction_category: :cheer)
      duplicate = build(:reaction, user: user, reactable: diary, reaction_category: :cheer)
      expect(duplicate).not_to be_valid
    end
  end

  describe "コールバック" do
    it "リアクション対象の投稿所有者に通知が作成される" do
      diary_owner = create(:user)
      reactor = create(:user)
      diary = create(:diary, user: diary_owner)
      reaction = build(:reaction, user: reactor, reactable: diary)
      expect(NotificationService).to receive(:create).with(sender: reactor, recipient: diary_owner, notifiable: anything)
      reaction.save
    end
  end
end
