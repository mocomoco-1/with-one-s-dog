class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User", optional: true
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(unread: true) }
end
