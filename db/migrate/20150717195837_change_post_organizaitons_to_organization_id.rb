class ChangePostOrganizaitonsToOrganizationId < ActiveRecord::Migration
  def change
    rename_column :posts, :organizations, :organization_id
  end
end
