class Api::LocationsController < Api::ApiController
  before_filter :find_post

  def show
    name = Location.new.lookup_name(params)
    loc = Location.find_by(name: name)

    posts = []
    Location.where(name: name).find_each do |location|
      if location.post.nil?
        next
      else
        posts << location.post
      end
    end

    render status: 200, json: {
                          message: 'Location found.',
                          location: loc,
                          posts: posts
                      }.to_json
  end

  def create
    locations = []
    locations << Location.new.create(location_params)

    if locations[0].save
      if @post && @current_user && @post.user == @current_user
        @post.locations << locations[0]
        @post.save

        render status: 200, json: {
                              message: 'Location created.',
                              post: @post,
                              locations: locations
                          }.to_json

      elsif @post && @post.user != @current_user
        render status: 401, json: {
                              message: 'Only the post creator can add this.',
                              post: @post,
                              locations: locations
                          }.to_json
      else

        render status: 200, json: {
                              message: 'Location created.',
                              post: @post,
                              locations: locations
                          }.to_json
      end
    else
      render status: 422, json: {
                            errors: location.errors
                        }.to_json
    end
  end

  def update
    location = Location.find(params[:id])

    if location.post.user != @current_user
      render status: 401, json: {
                            message: 'Only the post creator can update this.',
                            post: @post,
                            locations: location
                        }.to_json
    else
      if location.update_attributes(params[:id], location_params)
        location.reload

        render status: 200, json: {
                              message: 'Location updated.',
                              post: @post,
                              location: location
                          }.to_json
      else
        render status: 422, json: {
                              message: 'Location could not be updated.',
                              post: @post,
                              location: location
                          }.to_json
      end
    end
  end

  def destroy
    if @post && @current_user && @current_user == @post.user
      @post.location = location
      @post.location.destroy
      render status: 200, json: {
                            message: 'Location deleted.'
                        }.to_json
    else
      location = Location.find(params[:id])
      location.destroy
      render status: 401, json: {
                            message: 'Only post creator can delete that.'
                        }.to_json
    end

  end

  private
  def location_params
    params[:location].permit(:lat, :lon, :post_id)
  end

  def find_post
    if params[:post_id]
      @post = Post.find(params[:post_id])
      @current_user = User.find(session[:user_id]) if session[:user_id]
    else
      @post = nil
      @current_user = nil
    end
  end
end
