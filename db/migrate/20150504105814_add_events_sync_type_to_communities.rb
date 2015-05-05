class AddEventsSyncTypeToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :events_sync_type, :string

    add_index :communities, :events_sync_type
    add_index :posts, :title
  end
end
