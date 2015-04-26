class Api::CommunitiesController < Api::ApiController
  before_filter :authenticate, only: [:create, :update, :destroy, :add_user, :remove_user]

  def index
    communities = Community.all
    render json: communities.as_json
  end

  def show
    community = Community.find(params[:id])
    render json: community.as_json(include: :posts)
  end

  def create
    community = current_user.communities.new(community_params)
    community.created_by = current_user.id
    if community.save
      render status: 200, json: {
                            message: 'Community created.',
                            community: community,
                        }.to_json
    else
      render status: 422, json: {
                            errors: community.errors
                        }.to_json
    end
  end

  def update
    community = Community.find(params[:id])

    message = 'Community updated.'
    if params[:post_id]
      community.posts << Post.find(params[:post_id])
      message = 'Post added to Community.'
    end

    if community.created_by == current_user.id

      if community.update(community_params)
        render status: 200, json: {
                              message: message,
                              community: community,
                              posts: community.posts
                          }.to_json
      else
        render status: 422, json: {
                              message: 'Community could not be updated.',
                              post: post
                          }.to_json
      end
    else
      render status: 401, json: {
                            message: 'Only the community creator and update the community.',
                            community: community
                        }.to_json
    end
  end

  def add_user
    community = Community.find(params[:community_id])

    if current_user.id == community_params['user_ids'][0].to_i
      if community.update(community_params)
        render status: 200, json: {
                              message: 'User added to community.',
                              community: community,
                          }.to_json
      else
        render status: 422, json: {
                              message: 'User could not be added to community.',
                              community: community
                          }.to_json
      end
    else
      render status: 401, json: {
                            message: '"You can only add yourself to a community.",'
                        }.to_json
    end
  end

  def remove_user
    community = Community.find(params[:community_id])
    user = User.find(community_params['user_ids'][0].to_i)

    if current_user.id == community_params['user_ids'][0].to_i
      if community.users.delete(user)
        render status: 200, json: {
                              message: 'User removed to community.',
                              community: community,
                          }.to_json
      else
        render status: 422, json: {
                              message: 'User could not be removed to community.',
                              community: community
                          }.to_json
      end
    else
      render status: 401, json: {
                            message: 'You can only remove yourself from a community.',
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
