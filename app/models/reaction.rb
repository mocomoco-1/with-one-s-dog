class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactable, polymorphic: true

  validates :reaction_category, presence: true
  validates :user_id, uniqueness: { scope: [ :reactable_id, :reactable_type, :reaction_category ] }
  enum reaction_category: { cheer: 0, empathy: 1, amazing: 2, cry: 3, laugh: 4 }
  after_create :notify_reaction

  private

  def notify_reaction
    NotificationService.create(sender: user, recipient: reactable.user, notifiable: self)
  end
end
