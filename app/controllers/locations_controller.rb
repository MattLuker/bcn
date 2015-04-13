class LocationsController < ApplicationController
  before_action :find_post

  def index
  end

  def new
    @location = Location.new
  end

  def create
    @location = @post.create_location(location_params)

    if @location.save
      flash[:success] = "Post location added."
      redirect_to post_locations_path
    else
      flash[:alert] = "There was a problem adding the location."
      render action: :new
    end
  end

  def edit
    @location = @post.location
  end

  def update
    @location = @post.location

    if @location.update_attributes(location_params)
      flash[:success] = "Saved location."
      redirect_to post_locations_path
    else
      flash[:alert] = "There was a problem saving the location."
      render action: :edit
    end
  end

  def destroy
    @location = @post.location
    if @location.destroy
      flash[:success] = "Location was deleted."
    else
      flash[:alert] = "Location could not be deleted."
    end
    redirect_to "/posts/" + @post.id.to_s
  end

  def url_options
    { post_id: params[:post_id] }.merge(super)
  end

  private
  def find_post
    @post = Post.find(params[:post_id])
  end

  def location_params
    params[:location].permit(:lat, :lon, :post_id)
  end
end
