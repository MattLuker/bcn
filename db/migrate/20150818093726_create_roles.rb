class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, index: true
      t.integer :users
      t.integer :organizations
    end

    create_table :roles_users do |t|
      t.belongs_to :role, index: true
      t.belongs_to :user, index: true
    end

    create_table :organizations_roles do |t|
      t.belongs_to :role, index: true
      t.belongs_to :organization, index: true
    end
  end
end
