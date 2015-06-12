class RerenameCommunitesPosts < ActiveRecord::Migration
  def change
    rename_table :community_users, :communities_users
    rename_table :community_posts, :communities_posts
  end
end
