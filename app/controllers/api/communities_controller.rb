class Api::CommunitiesController < Api::ApiController
  before_filter :authenticate, only: [:update, :destroy]

  def index
    communities = Community.all
    render json: communities.as_json
  end

  def show
    community = Community.find(params[:id])
    render json: community.as_json(include: :posts)
  end

  def create
    community = Community.new(community_params)
    if community.save
      render status: 200, json: {
                            message: "Community created.",
                            community: community,
                        }.to_json
    else
      render status: 422, json: {
                            errors: community.errors
                        }.to_json
    end
  end

  def update
    puts params
    puts community_params.keys
    # Scope this to the current user.
    community = Community.find_by(created_by: current_user.id)
    if not community
      puts 'Did not find current_user Community...'
      # Only let the created_by user update the other Community attributes.
      if community_params.keys == 'user_ids'
        community = Community.find(params[:id])
      else
        render status: 401, json: {
                              message: "Only the Community creator can update those attributes.",
                              post: post
                          }.to_json
      end
    end

    # if current_user.id != community_params['user_ids'][0]
    #   render status: 401, json: {
    #                         message: "Sorry, you can only add yourself to a Community.",
    #                         post: post
    #                     }.to_json
    # end

    message = 'Community updated.'
    if params[:post_id]
      community.posts << Post.find(params[:post_id])
      message = 'Post added to Community.'
    end

    if community.update(community_params)
      render status: 200, json: {
                            message: message,
                            community: community,
                            posts: community.posts
                        }.to_json
    else
      render status: 422, json: {
                            message: "Community could not be updated.",
                            post: post
                        }.to_json
    end
  end

  def destroy
    community = Community.find(params[:id])

    message = 'Community deleted.'
    if params[:post_id]
      community.posts.delete(Post.find(params[:post_id]))
      message = 'Post removed from Community.'
    else
      community.destroy
    end

    render status: 200, json: {
                          message: message
                      }.to_json
  end

  private
  def community_params
    params.require('community').permit('name', 'description', 'created_by', :user_ids => [])
  end
end
