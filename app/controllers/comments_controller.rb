class CommentsController < ApplicationController
  before_action :find_post
  before_filter :require_user, only: [:update, :destroy]

  def create
    if current_user
      comment = @post.comments.new(comment_params)
      comment.user = current_user
    else
      comment = @post.comments.new(comment_params)
    end

    if comment.save
      flash[:success] = 'Comment added.'
    else
      flash[:info] = 'Problem adding comment.'
    end
    redirect_to @post
  end

  def update
    comment = Comment.find(params[:id])

    if comment.user == current_user
      if comment.update(comment_params)
        flash[:success] = 'Yay, comment updated.'
        redirect_to comment.post
      else
        flash[:alert] = 'Sorry, there was a problem updating your comment.'
        redirect_to comment.post
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    post = comment.post

    if comment.user == current_user || current_user.admin?
      if comment.destroy
        flash[:success] = 'Comment deleted.'
        redirect_to post
      else
        flash[:alert] = 'Sorry, there was a problem deleting your comment.'
        redirect_to comment.post
      end
    end
  end

  private
  def find_post
    @post = Post.find(params[:post_id]) if params[:post_id]
  end

  def comment_params
    params.require(:comment).permit(:content, :photo, :post, :user)
  end
end