class LocationsController < ApplicationController
  before_action :find_post

  def index
  end

  def show
    name = Location.new.lookup_name(params)
    @location = Location.find_by(name: name)

    @posts = []
    Location.where(name: name).find_each do |location|
      if location.post.nil?
        next
      else
        @posts << location.post
      end
    end
    render :show
  end

  def new
    @location = Location.new
  end

  def create
    #puts "location params: #{params}"
    @locations = @post.create_location(location_params)
    #@post.create_location(location_params)
    #puts "@locations[1].name: #{@locations[0].name}"

    if @locations
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
    @location = @post.locations.find(params[:id])
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
    @post = Post.find(params[:post_id]) if params[:post_id]
  end

  def location_params
    params[:location].permit(:lat, :lon, :post_id)
  end
end
