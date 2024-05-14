class UserNotification < ApplicationRecord
  belongs_to :notification
  belongs_to :user

  validates :read, inclusion: { in: [true, false] }
  validates :user_id, uniqueness: { scope: :notification_id }

  delegate :title, to: :notification, prefix: true
  delegate :url, to: :notification, prefix: true
end
