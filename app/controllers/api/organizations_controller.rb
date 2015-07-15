class Api::OrganizationsController < Api::ApiController
  before_filter :authenticate, only: [:create, :update, :destroy, :add_user, :remove_user]

  def index
    organizations = Organization.all
    render json: organizations.as_json
  end

  def show
    organization = Organization.find_by_slug(params[:id])
    render json: organization.as_json(include: :posts)
  end

  def create
    puts
    organization = current_user.organizations.new(organization_params)
    organization.created_by = current_user.id
    if organization.save
      render status: 200, json: {
                            message: 'Organization created.',
                            organization: organization,
                        }.to_json
    else
      render status: 422, json: {
                            errors: organization.errors
                        }.to_json
    end
  end

  def update
    organization = Organization.find(params[:id])

    message = 'Organization updated.'
    if params[:post_id]
      organization.posts << Post.find(params[:post_id])
      message = 'Post added to organization.'
    end

    if organization.created_by == current_user.id

      if organization.update(organization_params)
        render status: 200, json: {
                              message: message,
                              organization: organization,
                              posts: organization.posts
                          }.to_json
      else
        render status: 422, json: {
                              message: 'organization could not be updated.',
                              post: post
                          }.to_json
      end
    else
      render status: 401, json: {
                            message: 'Only the organization creator and update the organization.',
                            organization: organization
                        }.to_json
    end
  end

  def add_user
    organization = Organization.find(params[:organization_id])

    if current_user.id == organization_params['user_ids'][0].to_i
      user = User.find(organization_params['user_ids'][0].to_i)
      organization.users << user
      if organization.save
        render status: 200, json: {
                              message: 'User added to organization.',
                              organization: organization,
                          }.to_json
      else
        render status: 422, json: {
                              message: 'User could not be added to organization.',
                              organization: organization
                          }.to_json
      end
    else
      render status: 401, json: {
                            message: 'You can only add yourself to a organization.'
                        }.to_json
    end
  end

  def remove_user
    organization = Organization.find(params[:organization_id])
    user = User.find(organization_params['user_ids'][0].to_i)

    if current_user.id == organization_params['user_ids'][0].to_i
      if organization.users.delete(user)
        render status: 200, json: {
                              message: 'User removed to organization.',
                              organization: organization,
                          }.to_json
      else
        render status: 422, json: {
                              message: 'User could not be removed to organization.',
                              organization: organization
                          }.to_json
      end
    else
      render status: 401, json: {
                            message: 'You can only remove yourself from a organization.',
                        }.to_json
    end
  end

  def destroy
    organization = Organization.find(params[:id])

    message = 'organization deleted.'
    if params[:post_id]
      organization.posts.delete(Post.find(params[:post_id]))
      message = 'Post removed from organization.'
    else
      organization.destroy
    end

    render status: 200, json: {
                          message: message
                      }.to_json
  end

  private
  def organization_params
    params.require('organization').permit(:name,
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
