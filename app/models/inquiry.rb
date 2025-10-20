class Inquiry < ApplicationRecord
  validates :name, :email, :message, presence: true
end
