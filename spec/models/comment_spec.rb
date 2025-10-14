require 'rails_helper'

RSpec.describe Comment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { create(:user) }
  let(:diary) { create(:diary, user: user)}
  let(:comment) { build(:comment, user: user, commentable: diary)}
  describe "バリデーション" do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(65_535) }
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:commentable) }
    it { should have_many(:likes).dependent(:destroy) }
  end

  describe "コールバック" do
    it "コメント作成後にnotify_comment_ownerが呼ばれる" do
      allow(NotificationService).to receive(:create)
      comment.save
      expect(NotificationService).to have_received(:create).with(
        sender: user,
        recipient: diary.user,
        notifiable: comment
      )
    end
  end
end
