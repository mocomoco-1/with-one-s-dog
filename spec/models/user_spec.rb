require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "バリデーション" do
    it "有効な場合" do
      expect(build(:user)).to be_valid
    end

    context "無効な場合" do
      it "nameが空の場合無効" do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("を入力してください")
      end

      it "nameが20文字を超える場合無効" do
        user = build(:user, name: "a" * 21)
        expect(user).not_to be_valid
      end

      it "nameが重複している場合無効" do
        create(:user, name: "テスト")
        user = build(:user, name: "テスト")
        expect(user).not_to be_valid
      end

      it "emailが重複している場合" do
        create(:user, email: "testtest@example.com")
        user = build(:user, email: "testtest@example.com")
        expect(user).not_to be_valid
      end
    end
  end
  describe "アソシエーション" do
    it { should have_many(:consultations).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:reactions).dependent(:destroy) }
    it { should have_many(:chat_room_users).dependent(:destroy) }
    it { should have_many(:chat_rooms).through(:chat_room_users) }
    it { should have_many(:chat_messages).dependent(:destroy) }
    it { should have_many(:diaries).dependent(:destroy) }
    it { should have_many(:dog_profiles).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it {
      should have_many(:active_relationships)
        .class_name('Relationship')
        .with_foreign_key('follower_id')
        .dependent(:destroy)
    }
    it {
      should have_many(:passive_relationships)
        .class_name('Relationship')
        .with_foreign_key('followed_id')
        .dependent(:destroy)
    }
    it { should have_many(:followings).through(:active_relationships).source(:followed) }
    it { should have_many(:followers).through(:passive_relationships).source(:follower) }
    it { should have_many(:ai_consultations).dependent(:destroy) }
    it {
      should have_many(:sent_notifications)
        .class_name('Notification')
        .with_foreign_key('sender_id')
        .dependent(:nullify)
    }

    it {
      should have_many(:received_notifications)
        .class_name('Notification')
        .with_foreign_key('recipient_id')
        .dependent(:destroy)
    }
  end
  describe "インスタンスメソッド" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user, email: "other@example.com", name: "ほかユーザー") }
    context "#own?" do
      it "自分ならtrueを返す" do
        diary = create(:diary, user: user)
        expect(user.own?(diary)).to eq true
      end
      it "他人ならfalseを返す" do
        diary = create(:diary, user: other_user)
        expect(user.own?(diary)).to eq false
      end
    end
    context "#follow / #unfollow / #following?" do
      it "他ユーザーをフォローできる" do
        user.follow(other_user)
        expect(user.following?(other_user)).to be true
      end

      it "フォロー解除できる" do
        user.follow(other_user)
        user.unfollow(other_user)
        expect(user.following?(other_user)).to be false
      end

      it "自分はフォローできない" do
        expect { user.follow(user) }.not_to change { user.followings.count }
      end
    end
  end
end
