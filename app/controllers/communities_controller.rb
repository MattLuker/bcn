class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy, :podcast]
  before_filter :require_user, only: [:new, :create, :update, :destroy, :add_user, :remove_user]

  # GET /communities
  # GET /communities.json
  def index
    @communities = Community.all
  end

  def podcast
    puts "params #{params}"
    @user = User.find(@community.created_by)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  # GET /communities/1
  # GET /communities/1.json
  def show
  end

  # GET /communities/new
  def new
    @community = Community.new
  end

  # GET /communities/1/edit
  def edit
    if @community.created_by != current_user.id
      redirect_to @community, notice: 'Must be the creator of the Community to update it.'
    end
  end

  # POST /communities
  # POST /communities.json
  def create
    @community = Community.new(community_params)
    @community.created_by = current_user.id
    @community.users << current_user

    respond_to do |format|
      if @community.save
        format.html { redirect_to @community, notice: 'Community was successfully created.' }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communities/1
  # PATCH/PUT /communities/1.json
  def update
    respond_to do |format|
      if @community.created_by != current_user.id
        format.html { redirect_to @community, notice: 'Must be the creator of the Community to update it.' }
      else
        if @community.update(community_params)
          format.html { redirect_to @community, notice: 'Community was successfully updated.' }
          format.json { render :show, status: :ok, location: @community }
        else
          format.html { render :edit }
          format.json { render json: @community.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def add_user
    @community = Community.find(params[:community_id].to_i)

    if current_user.id == params['user_id'].to_i
      user = User.find(params['user_id'])
      @community.users << user
      if @community.save
        flash[:success] = "You are now part of the #{@community.name} community."
        FacebookSyncJob.perform_now(session[:facebook_auth], user) unless session[:facebook_auth].nil?
        redirect_to @community
      else
        redirect_to @community, notice: 'There was a problem adding you to the community'
      end
    else
      redirect_to communities_path, notice: 'You can only add yourself to a community.'
    end
  end

  def remove_user
    community = Community.find(params[:community_id].to_i)

    if current_user.id == params['user_id'].to_i
      @user = User.find(params['user_id'])
      if community.users.delete(@user)
        flash[:success] = "You have left the #{community.name} community."
        redirect_to @user
      else
        redirect_to @user, notice: 'There was a problem leaving the community'
      end
    else
      redirect_to @user, notice: 'You can only remove yourself from a community.'
    end
  end

  # DELETE /communities/1
  # DELETE /communities/1.json
  def destroy
    if @community.created_by == current_user.id
      @community.destroy
      respond_to do |format|
        format.html { redirect_to communities_url, notice: 'Community was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @community, notice: 'Community can only be deleted by creator.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id]) if params[:id]
      @community = Community.find(params[:community_id]) if params[:community_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_params
      params.require(:community).permit(:name, :description, :home_page, :color, :events_url, :user_ids => [])
    end
end
