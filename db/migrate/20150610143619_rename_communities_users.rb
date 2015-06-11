class RenameCommunitiesUsers < ActiveRecord::Migration
  def change
    rename_table :communities_users, :community_users
    rename_table :communities_posts, :community_posts
  end
end
