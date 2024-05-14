class Notification < ApplicationRecord
  has_many :user_notifications, dependent: :destroy
  has_many :users, through: :user_notifications

  validates :title, presence: true
  validates :url, presence: true, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/

  def notify(*user)
    users = user.flatten
    user_notifications = users.pluck(:id).map do |user_id|
      { notification_id: id, user_id: }
    end
    UserNotification.insert_all(user_notifications)
  end

  # def notify(users)
  #   users.each do |user|
  #     user.user_notifications.create(notification_id: id)
  #   end
  # end
end
