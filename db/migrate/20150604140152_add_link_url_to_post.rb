class AddLinkUrlToPost < ActiveRecord::Migration
  def change
    add_column :posts, :og_url, :string
    add_column :posts, :og_title, :string
    add_column :posts, :og_image, :string
    add_column :posts, :og_description, :string

    add_index :posts, :og_url
  end
end