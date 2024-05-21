# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!
  has_one_attached :profile_image
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :active_relationship, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy,
                                 inverse_of: :follower
  has_many :followings, through: :active_relationship, source: :followed
  has_many :passive_relationship, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy,
                                  inverse_of: :followed
  has_many :followers, through: :passive_relationship, source: :follower
  has_many :user_notifications, dependent: :destroy
  has_many :notifications, through: :user_notifications
  has_many :user_notification_timings
  has_many :notification_timings, through: :user_notification_timings

  validates :profile_image,
            blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..(5.megabytes) }
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  scope :recent, ->(count = 10) { order(created_at: :desc).limit(count) }

  def self.ransackable_attributes(_auth_object = nil)
    ['username']
  end

  def owner?(object)
    object.user_id == id
  end

  def like(post)
    like_posts << post
  rescue ActiveRecord::RecordInvalid
    false
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end

  def follow(user)
    followings << user
  rescue ActiveRecord::RecordInvalid
    false
  end

  def unfollow(user)
    followings.destroy(user)
  end

  def follow?(user)
    followings.include?(user)
  end

  def feed
    Post.where(user_id: following_ids << id)
  end

  def accept_notification?(type)
    notification_timings.find_by(timing_type: type).present?
  end
end
