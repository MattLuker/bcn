class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :require_user, only: [:edit, :update, :destroy, :remove_community]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
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
    @communities = Community.all
  end

  # GET /posts/1/edit
  def edit
    @communities = Community.all

    if not current_user
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
    if current_user
      @post = current_user.posts.new({title: post_params[:title], description: post_params[:description]})
    else
      @post = Post.new({title: post_params[:title], description: post_params[:description]})
    end

    post_params[:community_ids].each do |c|
      if not c.empty?
        community = Community.find(c.to_i)
        @post.communities << community
      end
    end
    if post_params[:lat] and post_params[:lon]
      @post.create_location(post_params)
    else
      @post.locations = []
    end

    respond_to do |format|
      if @post.save
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

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
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
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :lat, :lon, :community_ids => [])
    end
end
