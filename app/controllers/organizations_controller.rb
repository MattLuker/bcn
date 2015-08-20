class OrganizationsController < ApplicationController
  before_action :set_organization, except: [:index, :new, :create]
  before_action :require_user

  def show
    @posts = @organization.posts.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def podcast
    @user = User.find(@organization.created_by)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def index
    @organizations = Organization.all
  end

  def new
    @organization = Organization.new
  end

  def create
    if organization_params[:lat] and organization_params[:lon]
      lat = params[:organization].delete :lat
      lon = params[:organization].delete :lon
    end

    @organization = Organization.new(organization_params)
    @organization.password = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
    @organization.created_by = current_user.id
    @organization.users << current_user

    if lat and lon
      @organization.create_location({lat: lat, lon: lon})
    else
      @organization.location = nil
    end

    if @organization.save
      role = Role.create(name: 'leader', user: current_user, organization: @organization)
      current_user.roles << role
      current_user.save

      flash[:success] = 'Organization created.'
      redirect_to @organization
    else
      flash[:alert] = 'There was a problem creating the organization.'
      redirect_to new_organization_path
    end
  end

  def edit
    @roles = Role.where(organization: @organization.id)
    org_role = current_user.roles.find_by_organization_id(@organization.id)
    unless org_role && org_role.name == 'leader'
      redirect_to @organization, notice: 'Must be the creator of the Community to update it.'
    end
  end

  def update
    if (organization_params[:lat] && organization_params[:lon]) &&
        (!organization_params[:lat].blank? && !organization_params[:lon].blank?)
      lat = params[:organization].delete :lat
      lon = params[:organization].delete :lon
      @organization.create_location({lat: lat, lon: lon})
    else
      lat = params[:organization].delete :lat
      lon = params[:organization].delete :lon
    end

    if @organization.update(organization_params)
      flash[:success] = 'Organization updated.'
      redirect_to @organization
    else
      flash[:alert] = 'There was a problem updating the organization.'
      redirect_to :edit
    end
  end

  def destroy
    if @organization.destroy
      flash[:success] = 'Organization deleted.'
      redirect_to organizations_path
    else
      flash[:alert] = 'There was a problem deleting the organization.'
      redirect_to @organization
    end
  end

  def add_user
    if current_user.id == params['user_id'].to_i
      if Role.create(name: 'pending', user: current_user, organization: @organization)
        ApplyBadgesJob.perform_now(current_user)
        Notifier.user_join(current_user, @organization).deliver_now
        flash[:success] = "Your membership request to #{@organization.name} has been submitted."
        redirect_to @organization
      end
    end
  end

  def remove_user
    if current_user.id == params['user_id'].to_i || current_user.admin?
      @user = current_user
      if @organization.users.delete(current_user)
        flash[:success] = "You have left #{@organization.name}."
        redirect_to @user
      else
        redirect_to @user, notice: 'There was a problem leaving the organization.'
      end
    else
      redirect_to @user, notice: 'You can only remove yourself from a organization.'
    end
  end

  private
  def set_organization
    @organization = Organization.find_by_slug(params[:id]) if params[:id]
    @organization = Organization.find(params[:organization_id]) if params[:organization_id]
    @creator = User.find(@organization.created_by) if @organization.created_by
    @leaders = Role.where(organization: @organization, name: 'leader').collect { |u| u.user }
    @members = Role.where(organization: @organization, name: 'member').collect { |u| u.user }
    @penders = Role.where(organization: @organization, name: 'pending').collect { |u| u.user }
  end

  def organization_params
    params.require(:organization).permit(:name,
                                         :email,
                                         :description,
                                         :web_url,
                                         :image,
                                         :events_url,
                                         :color,
                                         :retained_image,
                                         :facebook_link,
                                         :twitter_link,
                                         :google_link,
                                         :lat,
                                         :lon

    )
  end
end