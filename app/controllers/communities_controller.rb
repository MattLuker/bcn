class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy, :podcast]
  before_filter :require_user, only: [:new, :create, :update, :destroy, :add_user, :remove_user]

  def index
    @communities = Community.popularity.all
  end

  def podcast
    @user = User.find(@community.created_by)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def show
  end

  def new
    @params = params
    @community = Community.new
  end

  def edit
    if @community.created_by != current_user.id
      redirect_to @community, notice: 'Must be the creator of the Community to update it.'
    end
  end

  def create
    if community_params[:lat] and community_params[:lon]
      lat = params[:community].delete :lat
      lon = params[:community].delete :lon
    end

    @community = Community.new(community_params)
    @community.created_by = current_user.id
    @community.users << current_user

    if lat and lon
      @community.create_location({lat: lat, lon: lon})
    else
      @community.location = nil
    end

    if @community.save
      redirect_to @community, notice: 'Community was successfully created.'
    else
      render :new
    end
  end

  def update
      if @community.created_by != current_user.id
        redirect_to @community, notice: 'Must be the creator of the Community to update it.'
      else
        if @community.update(community_params)
          redirect_to @community, notice: 'Community was successfully updated.'
        else
          render :edit, status: :unprocessable_entity
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
        FacebookSyncJob.perform_now(user.facebook_token, user) if user.facebook_token
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

    if current_user.id == params['user_id'].to_i || current_user.admin?
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

  def destroy
    if @community.created_by == current_user.id
      if @community.destroy
        redirect_to communities_url, notice: 'Community was successfully deleted.'
      else
        flash[:alert] = 'There was a problem deleting the community.'
        redirect_to @community
      end
    else
      redirect_to @community, notice: 'Community can only be deleted by creator.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find_by_slug(params[:id]) if params[:id]
      @community = Community.find_by_slug(params[:community_id]) if params[:community_id]
      @creator = User.find(@community.created_by) if @community.created_by
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_params
      params.require(:community).permit(:name,
                                        :description,
                                        :home_page,
                                        :color,
                                        :events_url,
                                        :image,
                                        :explicit,
                                        :facebook_link,
                                        :twitter_link,
                                        :google_link,
                                        :lat,
                                        :lon,
                                        :user_ids => [])
    end
end
