require 'rails_helper'

RSpec.describe Like, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:comment) }
  end

  describe "バリデーション" do
    it "同じユーザーは同じコメントに2度いいねできないこと" do
      comment = create(:comment)
      user = create(:user)
      create(:like, user:, comment:)
      duplicate_like = build(:like, user:, comment:)
      expect(duplicate_like).not_to be_valid
    end
  end
  describe "コールバック" do
    it "コメントの所有者に通知が作成されること" do
      comment_owner = create(:user)
      commenter = create(:user)
      comment = create(:comment, user: comment_owner)
      like = build(:like, user: commenter, comment: comment)
      expect(NotificationService).to receive(:create).with(sender: commenter, recipient: comment_owner, notifiable: anything)
      like.save
    end

    it "自分のコメントに言い値した場合は通知が作成されないこと" do
      user = create(:user)
      comment = create(:comment, user: user)
      like = build(:like, user: user, comment: comment)
      expect(NotificationService).not_to receive(:create)
      like.save
    end
  end
end
