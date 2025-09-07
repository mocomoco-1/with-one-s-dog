class DogProfile < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, presence: true
  validate :birthday_and_age_validation
  before_save :calculate_age_from_birthday

  private

  def birthday_and_age_validation
    if birthday.present? && age.present?
      errors.add(:age, "は誕生日が入力されている場合は自動で計算されます")
    end

    if age.present? && birthday_unknown == false && birthday.blank?
      errors.add(:age, "は誕生日不明の場合は入力してください")
    end
  end

  def calculate_age_from_birthday
    return if birthday.blank?
    today = Date.today
    calculated_age = today.year - birthday.year
    calculated_age -= 1 if today < birthday + calculated_age.years
    self.age = calculated_age
    self.birthday_unknown = false
  end
end
