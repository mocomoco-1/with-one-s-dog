class Consultation < ApplicationRecord
  include PgSearch::Model
  acts_as_taggable_on :tags
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 65_535 }

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :reactions, as: :reactable, dependent: :destroy
  pg_search_scope :search_similar,
                  against: [ :title, :content ],
                  using: {
                    tsearch: { prefix: true }, # 部分一致を可能に
                    trigram: {} # 文字列類似度も考慮
                  }
  def self.ransackable_attributes(auth_object = nil)
    %w[title content created_at updated_at]
  end
  # include(:user)と記載しているため必要
  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
