class RolesController < ApplicationController
  def update
    organization = Organization.find_by_slug(params[:organization_id])
    role = Role.find(params[:id])

    if role.update(role_params)
      organization.users << @role.user
      flash[:success] = 'Member status updated.'
      redirect_to edit_organization_path(organization)
    else
      flash[:error] = "There was a problem updating the Member's status."
      redirect_to edit_organization_path(organization)
    end
  end

  private
    def role_params
      params.require(:role).permit(:name)
    end

end