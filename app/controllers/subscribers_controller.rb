class SubscribersController < ApplicationController
  before_action :find_post
  before_filter :require_user, only: [:create, :destroy]

  def create
    if params[:user_id] != current_user.id.to_s
      render json: {subscriber: nil, status: 'error'}
    end

    subscriber = @post.subscribers.create(user: current_user)
    flash[:success] = 'Subscribed to post.'
    render json: {user_id: subscriber.user.id, post_id: @post.id, status: 'subscribed'}
  end

  def destroy
    subscriber = Subscriber.find_by_post_id(params[:post_id])
    subscriber.destroy if subscriber
    flash[:info] = 'Unsubscribed from post.'
    render json: {user_id: subscriber.user.id, post_id: @post.id, status: 'unsubscribed'}
  end

  private
  def find_post
    @post = Post.find(params[:post_id])
  end
end