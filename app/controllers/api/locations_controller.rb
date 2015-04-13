class Api::LocationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :find_post

  def create
    location = @post.create_location(location_params)
    location.save

    puts params
    # Do a post.save for the web form, but might just
    # do it through the map and change it to location.save ...
    if @post.save
      render status: 200, json: {
        message: "Location created.",
        post: @post,
        location: @post.location
      }.to_json
    else
      render status: 422, json: {
        errors: @post.errors
      }.to_json
    end
  end

  def update
    if @post.location.update_attributes(params[:id], location_params)
      puts "locations controller location_params: #{location_params}"
      @post.save
      render status: 200, json: {
        message: "Location updated.",
        post: @post,
        location: @post.location
      }.to_json
    else
      render status: 422, json: {
        message: "Location could not be updated.",
        post: @post
      }.to_json
    end
  end

  def destroy
    @post.location.destroy
    render status: 200, json: {
      message: "Location deleted."
    }.to_json
  end

  private
  def location_params
    params[:location].permit(:lat, :lon, :post_id)
  end

  def find_post
    @post = Post.find(params[:post_id])
  end
end
