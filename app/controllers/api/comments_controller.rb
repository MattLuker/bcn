class Api::CommentsController < Api::ApiController
  before_action :find_parent
  before_filter :authenticate, only: [:create, :update, :destroy]

  def show
    comment = Comment.find(params[:id])
    render json: comment.as_json
  end


  def create
    if @post
      comment = @post.comments.new(comment_params)
      comment.user = current_user if current_user
      ApplyBadgesJob.perform_now(current_user) if current_user
    elsif @parent_comment
      comment = @parent_comment.children.new(comment_params)
      comment.user = current_user if current_user
    end

    if comment.save
      # Send email to subscribers and Post User if there is one, Post User has an email, and
      # Post User is not a Subscriber.
      if current_user
        current_user.username.nil? ? commenter = 'Anonymous' : commenter = current_user.username
        ApplyBadgesJob.perform_now(current_user)
      else
        commenter = 'Anonymous'
      end
      comment.root.post.subscribers.each do |subscriber|
        unless current_user == subscriber.user
          CommentMailer.new_comment(subscriber.user, comment.root.post, comment, commenter).deliver_now
        end
      end
      if comment.root.post.user && comment.root.post.user.email &&
          comment.root.post.subscribers.find_by(user_id: comment.root.post.user).nil?
        CommentMailer.new_comment(comment.root.post.user, comment.root.post, comment, commenter).deliver_now
      end

      render status: 200, json: {
                            message: 'Comment created.',
                            comment: comment,
                        }.to_json
    else
      render status: 422, json: {
                            errors: comment.errors
                        }.to_json
    end
  end

  def update
    comment = Comment.find(params[:id])

    if comment.user == current_user
      if comment.update(comment_params)
        render status: 200, json: {
                              message: 'Comment updated.',
                              comment: comment,
                          }.to_json
      else
        render status: 422, json: {
                              errors: comment.errors
                          }.to_json
      end
    else
      render status: 401, json: {
                            message: 'Only the comment creator and update the comment.',
                            comment: comment
                        }.to_json
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
        render status: 200, json: {
                              message: 'Comment deleted.',
                          }.to_json
      else
        render status: 422, json: {
                              errors: comment.errors
                          }.to_json
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