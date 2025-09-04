class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20 }
  validates :email, uniqueness: { case_sensitive: false }

  has_many :consultations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :chat_room_users, dependent: :destroy
  has_many :chat_rooms, through: :chat_room_users
  has_many :chat_messages, dependent: :destroy
  has_many :diaries, dependent: :destroy

  def own?(resource)
    id == resource&.user_id
  end

  private

  def email_uniqueness_custom
    if User.exists?(email: email)
      errors.add(:email, "入力内容を確認してください")
    end
  end
end
