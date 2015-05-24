class RepliesController < ApplicationController
  before_action :find_comment
  before_filter :require_user, only: [:update, :destroy]

  def create
    if current_user
      reply = @comment.replies.new(replies_params)
      reply.user = current_user
    else
      reply = @comment.replies.new(replies_params)
    end

    if reply.save
      flash[:success] = 'Reply added.'
    else
      flash[:info] = 'Problem adding reply.'
    end
    redirect_to @comment.post
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
  def find_comment
    @comment = Comment.find(params[:comment_id]) if params[:comment_id]
  end

  def replies_params
    params.require(:reply).permit(:content, :photo, :comment, :user)
  end
end