class Users::RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    # rubocop:disable Style/GuardClause
    if current_user.follow(@user)
      create_notification_about_follow_to_followed_user(@user)
      if @user.accepted_notification?(:on_followed)
        UserMailer.with(user_from: current_user,
                        user_to: @user).follow.deliver_later
      end
    end
    # rubocop:enable Style/GuardClause
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
  end

  private

  def create_notification_about_follow_to_followed_user(user)
    notification = Notification.create!(title: "#{current_user.username}さんがあなたをフォローしました", url: user_url(current_user))
    notification.notify(user)
  end
end
