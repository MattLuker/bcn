class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :require_user, only: [:edit, :update, :destroy, :remove_community]

  autocomplete :community, :name, :full => true

  # GET /posts
  # GET /posts.json
  def index
    #@posts = Post.order('created_at DESC').all
    @posts = Post.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    if current_user
      @post = current_user.posts.new
    else
      @post = Post.new
    end
    @community_names = []
  end

  # GET /posts/1/edit
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

  # POST /posts
  # POST /posts.json
  def create
    if post_params[:lat] and post_params[:lon]
      lat = params[:post].delete :lat
      lon = params[:post].delete :lon
    end

    communities = set_communities

    if current_user
      @post = current_user.posts.new(post_params)
    else
      @post = Post.new(post_params)
    end

    if communities
      communities.each do |community|
        @post.communities << Community.find_by_name(community)
      end
    end

    if lat and lon
      @post.create_location({lat: lat, lon: lon})
    else
      @post.locations = []
    end

    respond_to do |format|
      if @post.save

        # Notify Community subscribers.
        unless @post.communities.blank?
          if current_user
            current_user.username.nil? ? poster = 'Anonymous' : poster = current_user.username
          else
            poster = 'Anonymous'
          end
          @post.communities.each do |community|
            community.subscribers.each do |subscriber|
              unless current_user == subscriber.user
                PostMailer.new_post(subscriber.user, @post, community, poster).deliver_now
              end
            end
          end
        end

        format.html {
          flash[:success] = 'Post was successfully created.'
          redirect_to @post
        }
        format.json { render :show, status: :created, locations: @post.locations }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_og_data
    p = Post.new
    og_data = p.get_og_attrs(params[:url])
    render json: og_data
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    communities = set_communities
    if communities
      new_communities = []
      communities.each do |community|
        # unless @post.communities.any? { |c| c.name == community }
        #   @post.communities << Community.find_by_name(community)
        # end
        new_communities.push(Community.find_by_name(community))
      end
      @post.communities = new_communities
    end

    if current_user != @post.user
      flash[:error] = 'You can only update your posts.'
      redirect_to home_index_path
    else
      respond_to do |format|
        if @post.update(post_params)
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

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    respond_to do |format|
      if current_user.posts.find(params[:id]).destroy
        format.html { redirect_to home_path, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      else
        flash[:error] = 'You must be logged in to delete a post.'
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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

    def set_communities
      if post_params[:community_names]
        communities = params[:post].delete :community_names
        communities = communities.split(',')
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
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
                                    :community_names,
                                    :og_url,
                                    :og_image,
                                    :og_title,
                                    :og_description,
                                    :explicit,
                                    :community_ids => [])
    end
end
