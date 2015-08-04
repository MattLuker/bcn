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
    @posts = @community.posts.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @params = params
    @community = Community.new
  end

  def edit
    unless current_user && current_user.admin?
      redirect_to @community
    end
  end

  def create
    if current_user && current_user.admin?
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
    else
      redirect_to communities_path
    end
  end

  def update
      unless current_user && current_user.admin?
        redirect_to @community, notice: 'Must be the creator of the Community to update it.'
      else
        if @community.update(community_params)
          redirect_to @community, notice: 'Community was successfully updated.'
        else
          render :edit, status: :unprocessable_entity
        end
      end
  end

  def add_member
    puts "params: #{params}"
    #@community = Community.find(params[:community_id].to_i)
    @community = Community.find_by_slug(params[:community_id])


    if params[:user_id]
      if current_user.id == params['user_id'].to_i
        @community.users << current_user
        if @community.save
          flash[:success] = "You are now part of the #{@community.name} community."
          ApplyBadgesJob.perform_now(current_user)
          redirect_to @community
        else
          redirect_to @community, notice: 'There was a problem adding you to the community'
        end
      else
        redirect_to @community, notice: 'You can only add yourself to a community.'
      end
    else
      organization = Organization.find(params[:organization_id]) if params[:organization_id]
      if organization.users.index(current_user)
        @community.organizations << organization
        if @community.save
          flash[:success] = "#{organization.name} is now part of #{@community.name}."
          ApplyBadgesJob.perform_now(current_user)
          redirect_to @community
        else
          redirect_to @community, notice: 'There was a problem adding the organization to the community'
        end
      else
        redirect_to @community, notice: 'You can only add organizations you are a part of to a community.'
      end
    end
  end

  def remove_member
    #community = Community.find(params[:community_id].to_i)
    @community = Community.find_by_slug(params[:community_id])

    if params[:user_id]
      if current_user.id == params[:user_id].to_i || current_user.admin?
        if @community.users.delete(current_user)
          flash[:success] = "You have left the #{@community.name} community."
          redirect_to current_user
        else
          redirect_to current_user, notice: 'There was a problem leaving the community'
        end
      else
        redirect_to current_user, notice: 'You can only remove yourself from a community.'
      end
    else
      organization = Organization.find(params[:organization_id])
      if @community.organizations.include?(organization) && organization.users.include?(current_user) || current_user.admin?
        if @community.organizations.delete(organization)
          flash[:success] = "You have removed #{organization.name} from #{@community.name}."
          redirect_to @community
        else
          redirect_to @community, notice: 'There was a problem removing the organization from the community'
        end
      else
        redirect_to @community, notice: 'You can only remove your organizations from a community.'
      end
    end
  end

  def destroy
    if current_user && current_user.admin?
      if @community.destroy
        redirect_to communities_path, notice: 'Community was successfully deleted.'
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
                                        :organization_id,
                                        :user_ids => [])
    end
end
