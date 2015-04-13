class CreateHabtmPostsCommunities < ActiveRecord::Migration
  def change
    add_column :posts, :communities, :integer
    add_column :communities, :posts, :integer

    create_table :posts_communities, id: false do |t|
      t.belongs_to :post, index: true
      t.belongs_to :community, index: true
    end
  end
end
