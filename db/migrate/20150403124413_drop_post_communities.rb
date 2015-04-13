class DropPostCommunities < ActiveRecord::Migration
  def change
    drop_table :posts_communities

    create_table :communities_posts, id: false do |t|
      t.belongs_to :post, index: true
      t.belongs_to :community, index: true
    end
  end
end
