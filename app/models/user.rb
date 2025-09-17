class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :line ]

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20 }
  validates :email, uniqueness: { case_sensitive: false }

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

  def own?(resource)
    id == resource&.user_id
  end

  def social_profile(provider)
    social_profiles.select{ |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]
    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end

  private

  def email_uniqueness_custom
    if User.exists?(email: email)
      errors.add(:email, "入力内容を確認してください")
    end
  end
end
