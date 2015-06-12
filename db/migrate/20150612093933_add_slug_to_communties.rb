class AddSlugToCommunties < ActiveRecord::Migration
  def change
    add_column :communities, :slug, :string
    add_index :communities, :slug
  end
end
