class RemoveCountsFromCommunities < ActiveRecord::Migration
  def change
    remove_column :communities, :users_count
    remove_column :communities, :posts_count
  end
end
