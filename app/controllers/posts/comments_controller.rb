class Posts::CommentsController < ApplicationController
  before_action :require_login

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def edit
    @comment = current_user.comments.find(params[:id])
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

  def show
    @comment = current_user.comments.find(params[:id])
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private
  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
