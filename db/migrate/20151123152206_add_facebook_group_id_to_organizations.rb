class AddFacebookGroupIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :facebook_group, :string
  end
end
