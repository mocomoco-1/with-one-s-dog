class Reaction < ApplicationRecord
  validates :reaction_type, presence: true
  validates :user_id, uniqueness: { scope: [:consultation_id, :reaction_type] }
  belongs_to :user
  belongs_to :consultation

  enum reaction_type: { cheer: 0, empathy: 1, amazing: 2, cry: 3, laugh: 4 }
end
