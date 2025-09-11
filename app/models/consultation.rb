class Consultation < ApplicationRecord
  acts_as_taggable_on :tags
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 65_535 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :reactions, as: :reactable, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[title content created_at updated_at]
  end
  # include(:user)と記載しているため必要
  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
