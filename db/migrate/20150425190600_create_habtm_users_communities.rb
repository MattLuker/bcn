class CreateHabtmUsersCommunities < ActiveRecord::Migration
  def change
    add_column :users, :communities, :integer
    add_column :communities, :users, :integer

    create_table :communities_users do |t|
      t.belongs_to :community, index: true
      t.belongs_to :user, index: true
    end

    # Also add a deleted_at to the users table.
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end
end
