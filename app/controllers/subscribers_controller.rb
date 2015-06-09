class SubscribersController < ApplicationController
  before_action :find_post
  before_filter :require_user, only: [:create, :destroy]

  def create
    puts params
    if params[:user_id] != current_user.id.to_s
      render json: {subscriber: nil, status: 'error'}
    end

    subscriber = @sub.subscribers.create(user: current_user)
    flash[:success] = "Subscribed to #{@type}."
    render json: {user_id: subscriber.user.id, @type + '_id' => @sub.id, status: 'subscribed'}
  end

  def destroy
    subscriber = Subscriber.find_by_post_id(params[:post_id])
    subscriber.destroy if subscriber
    flash[:info] = "Unsubscribed from #{@type}."
    render json: {user_id: subscriber.user.id, @type + '_id' => @sub.id, status: 'unsubscribed'}
  end

  private
  def find_post
    if params[:post_id]
      @sub = Post.find(params[:post_id])
      @type = 'post'
    elsif params[:community_id]
      @sub = Community.find(params[:community_id])
      @type = 'community'
    end
  end
end