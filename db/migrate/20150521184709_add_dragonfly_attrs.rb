class AddDragonflyAttrs < ActiveRecord::Migration
  def change
    add_column :users, :photo_uid,  :string
    add_column :users, :photo_name, :string

    add_column :posts, :image, :string
    add_column :posts, :image_uid,  :string
    add_column :posts, :image_name, :string
  end
end
