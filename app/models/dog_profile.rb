class DogProfile < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, presence: true
  validate :birthday_and_age_validation

  def display_age
    if birthday.present?
      dog_age = age_in_years_and_months
      "#{dog_age[:years]}歳#{dog_age[:months]}か月"
    elsif age.present?
      "#{age}歳 (推定)"
    else
      "年齢不明"
    end
  end
  def age_in_years_and_months
    return nil if birthday.blank?
    today = Date.today
    years = today.year - birthday.year
    months = today.month - birthday.month
    days = today.day - birthday.day

    if days < 0
      months -= 1
      prev_month = today << 1
      days += Date.new(prev_month.year,prev_month.month.month, -1).day
    end

    if months < 0
      years -= 1
      months += 12
    end
    { years: years, months: months, days: days }
  end

  private

  def birthday_and_age_validation
    if birthday.present? && age_changed? && age.present?
      errors.add(:age, "誕生日が入力されている場合、年齢は手入力できません")
    end
  end
end
