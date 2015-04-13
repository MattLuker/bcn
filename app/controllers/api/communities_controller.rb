class Api::CommunitiesController < ApplicationController
  skip_before_filter :verify_authenticity_token

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
    community = Community.find(params[:id])

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
    params.require("community").permit("name", "description")
  end
end
