class AddCommunityNameIndex < ActiveRecord::Migration
  def change
    add_index :communities, :name, unique: true
  end
end
