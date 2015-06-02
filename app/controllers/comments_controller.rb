class CommentsController < ApplicationController
  before_action :find_parent
  before_filter :require_user, only: [:update, :destroy]

  def show
    @comment = Comment.find(params[:id])
  end

  def create
    if @post
      comment = @post.comments.new(comment_params)
      comment.user = current_user if current_user
    elsif @parent_comment
      comment = @parent_comment.children.new(comment_params)
      comment.user = current_user if current_user
    end

    if comment.save
      flash[:success] = 'Comment added.'
    else
      flash[:info] = 'Problem adding comment.'
    end
    redirect_to comment.root.post
  end

  def update
    comment = Comment.find(params[:id])

    if comment.user == current_user
      if comment.update(comment_params)
        flash[:success] = 'Yay, comment updated.'
        redirect_to comment.root.post
      else
        flash[:alert] = 'Sorry, there was a problem updating your comment.'
        redirect_to comment.root.post
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
  def find_parent
    @post = Post.find(params[:post_id]) if params[:post_id]
    @parent_comment = Comment.find(params[:comment_id]) if params[:comment_id]
  end

  def comment_params
    params.require(:comment).permit(:content, :photo, :post, :user)
  end
end