class AdjustRoles < ActiveRecord::Migration
  def change
    remove_column :roles, :users
    remove_column :roles, :organizations

    add_column :roles, :user_id, :integer
    add_column :roles, :organization_id, :integer

    add_index :roles, :user_id
    add_index :roles, :organization_id
  end
end
