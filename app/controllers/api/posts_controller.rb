class Api::PostsController < Api::ApiController
  before_filter :authenticate, only: [:create, :update, :destroy]

  def index
    posts = Post.where(start_date: nil).order('created_at DESC').paginate(:page => params[:page], :per_page => 6)
    render json: posts.as_json(include: :location)
  end

  def events
    case params[:events]
    when 'today'
      today = DateTime.now
      events = Post.where(['start_date between ? and ?', today.beginning_of_day, today.end_of_day]).order(:start_date).paginate(:page => params[:page], :per_page => 20)
    when 'tomorrow'
      tomorrow = DateTime.now + 1
      events = Post.where(['start_date between ? and ?', tomorrow.beginning_of_day, tomorrow.end_of_day]).order(:start_date).paginate(:page => params[:page], :per_page => 20)
    when 'next_week'
      events = Post.where(start_date: Time.now.next_week..Time.now.next_week.end_of_week).order(:start_date).paginate(:page => params[:page], :per_page => 20)
    else
      events = Post.where(['start_date = ? or start_date > ?', DateTime.now, DateTime.now]).order(:start_date).paginate(:page => params[:page], :per_page => 20)
    end
    render json: events.as_json(include: :location)
  end

  def show
    post = Post.find(params[:id])
    render json: post.as_json(include: :locations)
  end

  def today
    @posts = Post.where(start_date: Date.today)
    render json: @posts.as_json
  end

  def tomorrow
    @posts = Post.where(start_date: Date.tomorrow)
    render json: @posts.as_json
  end

  def next_week
    @posts = Post.where(start_date: Time.now.next_week..Time.now.next_week.end_of_week)
    render json: @posts.as_json
  end

  def create
    if post_params['lat'] and post_params['lon']
      lat = params[:post].delete :lat
      lon = params[:post].delete :lon
    end

    if current_user
      post = current_user.posts.new(post_params)
    else
      post = Post.new(post_params)
    end
    post.create_location({lat: lat, lon: lon}) if lat and lon

    if post.save

      # Notify Community subscribers.
      unless post.communities.blank?
        if current_user
          current_user.username.nil? ? poster = 'Anonymous' : poster = current_user.username
          ApplyBadgesJob.perform_now(current_user)

        else
          poster = 'Anonymous'
        end
        post.communities.each do |community|
          community.subscribers.each do |subscriber|
            unless current_user == subscriber.user
              if subscriber.user.notify_instant
                PostMailer.new_post(subscriber.user, post, community, poster).deliver_now
              end
            end
          end
        end
      end

      # Add the Organization's Communitites and Location if posting as an Org.
      if post.organization
        if post.organization.location
          post.locations << post.organization.location
        end
        unless post.organization.communities.blank?
          post.communities << post.organization.communities
        end
        post.save
      end

      render status: 200, json: {
        message: 'Post created.',
        post: post,
        locations: post.locations
      }.to_json
    else
      render status: 422, json: {
        errors: post.errors
      }.to_json
    end
  end

  def update
    begin
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
                              locations: post.locations,
                              communities: post.communities
                          }.to_json
      else
        render status: 422, json: {
                              message: 'Post could not be updated.',
                              post: post
                          }.to_json
      end
    rescue
      render status: 404, json: {
                            message: 'Only post creator can update it.',
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
    params.require('post').permit(:title,
                                  :description,
                                  :lat,
                                  :lon,
                                  :location_id,
                                  :user_id,
                                  :start_date,
                                  :start_time,
                                  :end_date,
                                  :end_time,
                                  :image,
                                  :audio,
                                  :community_names,
                                  :og_url,
                                  :og_image,
                                  :og_title,
                                  :og_description,
                                  :community_ids => [])
  end
end
