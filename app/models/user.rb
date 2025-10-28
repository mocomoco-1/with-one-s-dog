class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [ :line ]

  validates :name, presence: true, uniqueness: { case_sensitive: true }, length: { maximum: 20 }
  validates :email, uniqueness: { case_sensitive: true }, unless: -> { provider == "line" }

  has_one_attached :image
  has_many :consultations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :chat_room_users, dependent: :destroy
  has_many :chat_rooms, through: :chat_room_users
  has_many :chat_messages, dependent: :destroy
  has_many :diaries, dependent: :destroy
  has_many :dog_profiles, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :ai_consultations, dependent: :destroy
  has_many :sent_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :nullify
  has_many :received_notifications, class_name: "Notification", foreign_key: "recipient_id", dependent: :destroy

  def own?(resource)
    id == resource&.user_id
  end

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]
    self.access_token = credentials["token"] if respond_to?(:access_token)
    self.refresh_token = credentials["refresh_token"] if respond_to?(:refresh_token)
    self.credentials = credentials.to_json if respond_to?(:credentials)
    self.name = info["name"].presence || self.name
    self.image = info["image"] || info["pictureUrl"] if respond_to?(:image)
    self.email ||= "#{uid}-#{provider}@example.com" if email.blank?
    save if changed?
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end

  def follow(other_user)
    followings << other_user unless self == other_user
  end

  def unfollow(other_user)
    followings.delete(other_user)
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  private

  def email_uniqueness_custom
    if User.exists?(email: email)
      errors.add(:email, "入力内容を確認してください")
    end
  end
end
