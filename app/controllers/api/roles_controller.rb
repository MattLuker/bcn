class Api::OrganizationsController < Api::ApiController
  before_filter :authenticate, only: [:create, :update, :destroy, :add_user, :remove_user]

  def update
    organization = Organization.find_by_slug(params[:organization_id])
    role = Role.find(params[:id])
    if role_params[:name] == 'remove'
      if role.destroy
        Notifier.join_status(role.user, organization, nil).deliver_now

        render status: 200, json: {
                              message: 'Member status updated.',
                              organization: organization,
                          }.to_json
      end
    else
      if role.update(role_params)
        organization.users << role.user
        Notifier.join_status(role.user, organization, role).deliver_now

        render status: 200, json: {
                              message: 'Member status updated.',
                              organization: organization,
                          }.to_json
      else
        render status: 422, json: {
                              errors: role.errors
                          }.to_json
      end
    end

  end

end