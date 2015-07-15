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
    puts "params: #{params}"
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
      flash[:success] = 'Organization created.'
      redirect_to @organization
    else
      puts "organization.errors: #{@organization.errors.inspect}"
      flash[:alert] = 'There was a problem creating the organization.'
      redirect_to new_organization_path
    end
  end

  def edit
    if @organization.created_by != current_user.id
      redirect_to @organization, notice: 'Must be the creator of the Community to update it.'
    end
  end

  def update
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
      redirect_to organization_path
    else
      flash[:alert] = 'There was a problem deleting the organization.'
      redirect_to @organization
    end
  end

  private
  def set_organization
    @organization = Organization.find_by_slug(params[:id]) if params[:id]
    @organization = Organization.find_by_slug(params[:organization_id]) if params[:organization_id]
    @creator = User.find(@organization.created_by) if @organization.created_by
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