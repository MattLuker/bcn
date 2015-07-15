class OrganizationsController < ApplicationController
  before_action :set_organization, except: [:new, :create]
  before_action :require_user

  def show
  end

  def index
    @organizations = Organization.all
  end

  def new
    puts "params: #{params}"
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    @organization.password = (0...50).map { ('a'..'z').to_a[rand(26)] }.join

    if @organization.save
      flash[:success] = 'Organization created.'
      redirect_to @organization
    else
      puts "organization.errors: #{@organization.errors.inspect}"
      flash[:alert] = 'There was a problem creating the organization.'
      redirect_to new_organization_path
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
    @organization = Organization.find(params[:id])
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

    )
  end
end