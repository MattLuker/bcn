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
      # Send email to subscribers and Post User if there is one, Post User has an email, and
      # Post User is not a Subscriber.
      current_user.username.nil? ? commenter = 'Anonymous' : commenter = current_user.username
      comment.root.post.subscribers.each do |subscriber|
        unless current_user == subscriber.user
          CommentMailer.new_comment(subscriber.user, comment.root.post, comment, commenter).deliver_now
        end
      end
      if comment.root.post.user && comment.root.post.user.email &&
          comment.root.post.subscribers.find_by(user_id: comment.root.post.user).nil?
        CommentMailer.new_comment(comment.root.post.user, comment.root.post, comment, commenter).deliver_now
      end

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

    # Don't delete the children.
    #
    # Another way to handle this is to not allow deletion if a comment has children.
    #
    comment.raise_children
    comment.reload

    if comment.user == current_user || current_user.admin?
      if comment.destroy
        flash[:success] = 'Comment deleted.'
        redirect_to comment.root.post
      else
        flash[:alert] = 'Sorry, there was a problem deleting your comment.'
        redirect_to comment.root.post
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