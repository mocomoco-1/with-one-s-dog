class Reaction < ApplicationRecord
  validates :reaction_category, presence: true
  validates :user_id, uniqueness: { scope: [ :consultation_id, :reaction_category ] }
  belongs_to :user
  belongs_to :reactable, polymorphic: true

  enum reaction_category: { cheer: 0, empathy: 1, amazing: 2, cry: 3, laugh: 4 }
end
