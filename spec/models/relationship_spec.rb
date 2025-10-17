require 'rails_helper'

RSpec.describe Relationship, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "アソシエーション" do
    it { should belong_to(:follower).class_name("User") }
    it { should belong_to(:followed).class_name("User") }
  end

  describe "バリデーション" do
    it { should validate_presence_of(:follower_id) }
    it { should validate_presence_of(:followed_id) }
    it { should validate_uniqueness_of(:follower_id).scoped_to(:followed_id) }
  end

  describe "コールバック" do
    it "フォローされたユーザーに通知が作成されること" do
      follower = create(:user)
      followed = create(:user)
      relationship = build(:relationship, follower: follower, followed: followed)
      expect(NotificationService).to receive(:create).with(sender: follower, recipient: followed, notifiable: anything)
      relationship.save
    end
  end
end
