class Api::CommunitiesController < Api::ApiController
  before_filter :authenticate, only: [:create, :update, :destroy, :add_user, :remove_user]

  def index
    communities = Community.all
    render json: communities.as_json
  end

  def show
    community = Community.find_by_slug(params[:id])
    community = Community.find(params[:id]) if community.nil?
    render json: community.as_json(include: :posts)
  end

  def create
    community = current_user.communities.new(community_params)
    community.created_by = current_user.id
    if community.save
      ApplyBadgesJob.perform_now(current_user)
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

  def add_member
    #@community = Community.find(params[:community_id].to_i)
    @community = Community.find_by_slug(params[:community_id])

    organization = Organization.find(params[:organization_id]) if params[:organization_id]
    if organization.users.index(current_user)
      @community.organizations << organization
      if @community.save
        ApplyBadgesJob.perform_now(current_user)
        render status: 200, json: {
                              message: "#{organization.name} is now part of #{@community.name}.",
                              community: community,
                          }.to_json
      else
        render status: 422, json: {
                              message: 'There was a problem adding the organization to the community',
                              community: community
                          }.to_json
      end
    else
      render status: 401, json: {
                            message: 'You can only add organizations you are a part of to a community.'
                        }.to_json
    end
  end

  def remove_member
    #community = Community.find(params[:community_id].to_i)
    @community = Community.find_by_slug(params[:community_id])

    organization = Organization.find(params[:organization_id])
    if @community.organizations.include?(organization) && organization.users.include?(current_user) || current_user.admin?
      if @community.organizations.delete(organization)
        render status: 200, json: {
                              message: "You have removed #{organization.name} from #{@community.name}.",
                              community: community,
                          }.to_json
      else
        render status: 422, json: {
                              message: 'There was a problem removing the organization from the community.',
                              community: community
                          }.to_json
      end
    else
      render status: 401, json: {
                            message: 'You can only remove your organizations from a community.',
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
    params.require('community').permit(:name,
                                       :description,
                                       :home_page,
                                       :color,
                                       :events_url,
                                       :image,
                                       :created_by,
                                       :facebook_link,
                                       :twitter_link,
                                       :google_link,
                                       :user_ids => [])
  end
end
