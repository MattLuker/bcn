class Api::PostsController < Api::ApiController
  before_filter :authenticate, only: [:update, :destroy]

  def index
    posts = Post.all
    render json: posts.as_json(include: :location, include: :communities)
  end

  def show
    post = Post.find(params[:id])
    render json: post.as_json(include: :location, include: :communities)
  end

  def create
    if current_user
      post = current_user.posts.new(post_params)
    else
      post = Post.new(post_params)
    end

    if post.save
      render status: 200, json: {
        message: 'Post created.',
        post: post,
        location: post.location
      }.to_json
    else
      render status: 422, json: {
        errors: post.errors
      }.to_json
    end
  end

  def update
    post = current_user.posts.find(params[:id])

    message = 'Post updated.'
    if params[:community_id]
      post.communities << Community.find(params[:community_id])
      message = 'Community added to Post.'
    end

    if post.update(post_params)
      render status: 200, json: {
        message: message,
        post: post,
        location: post.location,
        communities: post.communities
      }.to_json
    else
      render status: 422, json: {
        message: 'Post could not be updated.',
        post: post
      }.to_json
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])

    message = 'Post deleted.'
    if params[:community_id]
      post.communities.delete(Community.find(params[:community_id]))
      message = 'Community removed from Post.'
    else
      post.destroy
    end

    render status: 200, json: {
      message: message
    }.to_json
  end

  private
  def post_params
    params.require('post').permit('title', 'description', :lat, :lon, :user_id, :community_ids => [])
  end
end
