class RolesController < ApplicationController
  before_action :require_user

  def update
    organization = Organization.find_by_slug(params[:organization_id])
    role = Role.find(params[:id])
    if role_params[:name] == 'remove'
      if role.destroy
          organization.users.delete(role.user)
          Notifier.join_status(role.user, organization, nil).deliver_now

        flash[:success] = 'Member status updated.'
        redirect_to organization_path(organization)
      else
        flash[:error] = "There was a problem updating the Member's status."
        redirect_to edit_organization_path(organization)
      end
    else
      if role.update(role_params)
        organization.users << role.user
        flash[:success] = 'Member status updated.'

        # Send member notification of status update.
        Notifier.join_status(role.user, organization, role).deliver_now

        redirect_to organization_path(organization)
      else
        flash[:error] = "There was a problem updating the Member's status."
        redirect_to edit_organization_path(organization)
      end
    end

  end

  private
    def role_params
      params.require(:role).permit(:name)
    end

end