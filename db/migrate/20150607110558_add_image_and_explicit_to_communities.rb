class AddImageAndExplicitToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :image, :string
    add_column :communities, :image_uid, :string
    add_column :communities, :image_name, :string
    add_column :communities, :explicit, :boolean
  end
end
