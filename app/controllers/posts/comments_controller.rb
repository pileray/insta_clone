class Posts::CommentsController < ApplicationController
  before_action :require_login

  def show
    @comment = current_user.comments.find(params[:id])
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def create
    @comment = current_user.comments.build(comment_params)
    # rubocop:disable Style/GuardClause
    if @comment.save
      create_notification_about_comment_to_own_user(@comment)
      UserMailer.with(user_from: current_user, user_to: @comment.post.user,
                      comment: @comment).comment_post.deliver_later
    end
    # rubocop:enable Style/GuardClause
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_params)
    # turbo-frameでの実装の場合
    # if @comment.update(comment_params)
    #   # redirect_to @comment.post
    #   @comments = @comment.post.comments
    #   render 'posts/show'
    # else
    #   render :edit, status: :unprocessable_entity
    # end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def create_notification_about_comment_to_own_user(comment)
    user = comment.post.user
    notification = Notification.create!(title: "#{comment.user.username}さんがあなたの投稿にコメントしました",
                                        url: post_url(comment.post))
    notification.notify(user)
  end
end
