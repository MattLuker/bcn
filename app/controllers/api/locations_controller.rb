class Api::LocationsController < Api::ApiController
  before_filter :find_post

  def create
    location = Location.new.create(location_params)

    if location.save
      if @post
        @post.locations << location
        @post.save
      end

      render status: 200, json: {
                            message: 'Location created.',
                            post: @post,
                            locations: @post.locations
                        }.to_json
    else
      render status: 422, json: {
                            errors: location.errors
                        }.to_json
    end
  end

  def update
    location = Location.find(params[:id])

    if location.update_attributes(params[:id], location_params)
      location.reload

      # if @post
      #   # Remove the existing location and/or add the new one.
      #   @post.locations.each do |loc|
      #     if location.id == loc.id
      #       @post.locations.delete(loc)
      #       #else
      #     #  @post.locations << location
      #     end
      #
      #     @post.locations << location
      #     @post.save
      #   end
      # end

      #location.save
      #@post.save

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

  def destroy
    if @post
      @post.location = location
      @post.location.destroy
    else
      location = Location.find(params[:id])
      location.destroy
    end

    render status: 200, json: {
      message: 'Location deleted.'
    }.to_json
  end

  private
  def location_params
    params[:location].permit(:lat, :lon, :post_id)
  end

  def find_post
    if params[:post_id]
      @post = Post.find(params[:post_id])
    else
      @post = nil
    end
  end
end
