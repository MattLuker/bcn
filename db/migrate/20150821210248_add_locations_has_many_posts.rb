class AddLocationsHasManyPosts < ActiveRecord::Migration
  def change
    add_column :posts, :locations, :integer

    remove_column :locations, :post_id
    add_column :locations, :posts, :integer

    create_table :locations_posts, id: false do |t|
      t.belongs_to :post, index: true
      t.belongs_to :location, index: true
    end
  end
end
