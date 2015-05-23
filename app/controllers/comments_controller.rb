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
    if comment.update(comment_params)
      flash[:success] = 'Yay, comment updated.'
      redirect_to comment.post
    else
      flash[:alert] = 'Sorry, there was a problem updating your comment.'
      redirect_to comment.post
    end
  end

  def destroy
    puts "params: #{params}"

  end

  private
  def find_post
    @post = Post.find(params[:post_id]) if params[:post_id]
  end

  def comment_params
    params.require(:comment).permit(:content, :post, :user)
  end
end