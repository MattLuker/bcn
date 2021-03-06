class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :require_user, only: [:edit, :update, :destroy, :remove_community]
  helper_method :sort_column

  def index
    case params[:sort]
    when 'organization'
      @posts = Post.where('start_date is NULL').includes(:organization).order('organizations.name asc').paginate(:page => params[:page], :per_page => 20)
    when 'community'
      @posts = Post.where('start_date is NULL').includes(:communities).order('communities.name asc').paginate(:page => params[:page], :per_page => 20)
    else
      @posts = Post.where('start_date is NULL').order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
    end
  end

  def events
    case params[:events]
    when 'today'
      today = DateTime.now
      @events = Post.where(['start_date between ? and ?', today.beginning_of_day, today.end_of_day]).order(:start_date).paginate(:page => params[:page], :per_page => 20)
    when 'tomorrow'
      tomorrow = DateTime.now + 1
      @events = Post.where(['start_date between ? and ?', tomorrow.beginning_of_day, tomorrow.end_of_day]).order(:start_date).paginate(:page => params[:page], :per_page => 20)
    when 'next_week'
      @events = Post.where(start_date: Time.now.next_week..Time.now.next_week.end_of_week).order(:start_date).paginate(:page => params[:page], :per_page => 20)
    else
      @events = Post.where(['start_date = ? or start_date > ?', DateTime.now, DateTime.now]).order(:start_date).paginate(:page => params[:page], :per_page => 20)
    end

    case params[:sort]
    when 'organization'
      @events = Post.where(['start_date = ? or start_date > ?', DateTime.now, DateTime.now]).includes(:organization).order('organizations.name asc')
        .order(:start_date).paginate(:page => params[:page], :per_page => 20)
    when 'community'
      @events = Post.where(['start_date = ? or start_date > ?', DateTime.now, DateTime.now]).includes(:communities).order('communities.name asc')
        .order(:start_date).paginate(:page => params[:page], :per_page => 20)
    else
      @events = Post.where(['start_date = ? or start_date > ?', DateTime.now, DateTime.now]).order(:start_date).paginate(:page => params[:page], :per_page => 20)
    end
  end

  def show
    @gallery = @post.comments.collect { |c| c.photo.url if c.photo } if @post.comments
    unless @post.image
      @post.set_image
    end
  end

  def new
    @communities = Community.all

    if current_user
      @post = current_user.posts.new
    else
      @post = Post.new
    end
    @community_names = []
    @photo = Photo.new
  end

  def edit
    @communities = Community.all
    @community_names = @post.communities.map { |c| c.name }.join(',') + ','

    unless current_user
      if current_user != @post.user
        flash[:error] = 'You can only update your posts.'
        redirect_to login_path
      else
        flash[:info] = 'You must be logged in to update a post.'
        redirect_to new_user_session_path
      end
    end
  end

  def create
    unless params[:post][:favorite].blank?
      redirect_to posts_path
    else

      if post_params[:lat] and post_params[:lon]
        lat = params[:post].delete :lat
        lon = params[:post].delete :lon
      end

      # Remove community_ids if field not filled out on iOS cause it sends "null" anyway.
      params[:post].delete :community_ids if params[:post][:community_ids] == ["null"]

      if current_user
        @post = current_user.posts.new(post_params)
      else
        @post = Post.new(post_params)
      end

      if lat and lon
        @post.create_location({lat: lat, lon: lon})
      else
        @post.locations = []
      end

      if @post.save
        if post_params[:community_ids]
          post_params[:community_ids].each do |c|
            unless c.blank?
              community = Community.find(c)

              @post.locations << community.location if community.location
              @post.save

              community.save
            end
          end

          # Add the Organization's Communitites and Location if posting as an Org.
          if @post.organization
            if @post.organization.location
             @post.locations << @post.organization.location
            end
            unless @post.organization.communities.blank?
              # Only add the Organization Communities that aren't added by the form input.
              @post.organization.communities.each do |org_community|
                unless @post.communities.include?(org_community)
                  @post.communities << org_community
                end
              end
            end
            @post.save
          end
        end

        # Notify Community subscribers.
        notify_community_subscribers

        add_multi_upload

        flash[:success] = 'Post was successfully created.'
        redirect_to @post
      end
    end
  end

  def get_og_data
    p = Post.new
    og_data = p.get_og_attrs(params[:url])
    render json: og_data
  end

  def update
    if current_user != @post.user
      flash[:error] = 'You can only update your posts.'
      redirect_to home_index_path
    else
      respond_to do |format|
        if @post.update(post_params)
          notify_subscribers

          add_multi_upload

          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def remove_community
    @post = Post.find(params[:post_id])

    if current_user.id == params['user_id'].to_i
      community = Community.find(params['community_id'])
      if @post.communities.delete(community)
        flash[:success] = "Community #{community.name} removed."
        redirect_to @post
      else
        redirect_to @post, notice: 'There was a problem removing the community'
      end
    else
      redirect_to @post, notice: 'Only the post creator can remove a community.'
    end
  end

  def destroy
    respond_to do |format|

      if @post.user == current_user || current_user.admin?
        if @post.destroy
          format.html { redirect_to home_path, notice: 'Post was successfully destroyed.' }
          format.json { head :no_content }
        else
          flash[:error] = 'You must be logged in to delete a post.'
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      else
        flash[:info] = 'Not allowed to delete this post.'
        redirect_to @post
      end
    end
  end

  def add_multi_upload
    if params[:photos]
      params[:photos].each do |photo|
        photo = Photo.create(image: photo)
        photo.post = @post
        photo.save
      end
    end

    if params[:audios]
      params[:audios].each do |file|
        audio = Audio.create(audio: file)
        audio.post = @post
        audio.save
      end
    end
  end

  private
    def sort_column
      params[:sort] if params[:sort]
    end

    def notify_community_subscribers
      unless @post.communities.blank?
        if current_user
          current_user.username.nil? ? poster = 'Anonymous' : poster = current_user.username
        else
          poster = 'Anonymous'
        end
        @post.communities.each do |community|
          community.subscribers.each do |subscriber|
            unless current_user == subscriber.user
              if subscriber.user && subscriber.user.email && subscriber.user.notify_instant
                PostMailer.new_post(subscriber.user, @post, community, poster).deliver_now
              end
            end
          end
        end
      end

      unless @post.organization.nil?
        if current_user
          current_user.username.nil? ? poster = 'Anonymous' : poster = current_user.username
        else
          poster = 'Anonymous'
        end
        @post.organization.subscribers.each do |subscriber|
          unless current_user == subscriber.user
            if subscriber.user && subscriber.user.email && subscriber.user.notify_instant
              PostMailer.new_post(subscriber.user, @post, @post.organization, poster).deliver_now
            end
          end
        end
      end
    end

    def notify_subscribers
      if @post.user
        @post.user.username.nil? ? poster = 'Anonymous' : poster = @post.user.username
      else
        poster = 'Anonymous'
      end
      @post.subscribers.each do |subscriber|
        if subscriber.user && subscriber.user.email && subscriber.user.notify_instant
          PostMailer.post_updated(subscriber.user, @post, poster).deliver_now
        end
      end
    end

    def set_post
      if current_user
        begin
          @post = current_user.posts.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
          # Be able to view a post if logged in, but not the Post.user.
          @post = Post.find(params[:id])
        end
      else
        @post = Post.find(params[:id])
      end
    end

    def post_params
      params.require('post').permit(:title,
                                    :description,
                                    :lat,
                                    :lon,
                                    :location_id,
                                    :user_id,
                                    :start_date,
                                    :end_date,
                                    :start_time,
                                    :end_time,
                                    :image,
                                    :audio,
                                    :community_ids,
                                    :og_url,
                                    :og_image,
                                    :og_title,
                                    :og_description,
                                    :explicit,
                                    :organization_id,
                                    :community_ids => [])
    end
end
