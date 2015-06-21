class Api::SubscribersController < Api::ApiController
  before_action :find_post
  before_filter :authenticate, only: [:create, :destroy]


  def create
    if params[:user_id] != current_user.id.to_s
      render json: {subscriber: nil, status: 'error'}
    end

    subscriber = @sub.subscribers.create(user: current_user)

    if subscriber
      render status: 200, json: {
                            message: 'User subscribed.',
                            @type => @sub,
                            user: subscriber.user,
                            @type + '_id' => @sub.id
                        }.to_json
    else
      render status: 422, json: {
                            errors: post.errors
                        }.to_json
    end
  end

  def destroy
    subscriber = Subscriber.find_by_post_id(params[:post_id])
    subscriber.destroy if subscriber

    render status: 200, json: {
                          message: 'User unsubscribed.',
                          @type => @sub,
                          user: subscriber.user,
                          @type + '_id' => @sub.id
                      }.to_json
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