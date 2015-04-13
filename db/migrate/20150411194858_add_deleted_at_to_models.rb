class AddDeletedAtToModels < ActiveRecord::Migration
  def change
    add_column :posts, :deleted_at, :datetime
    add_index :posts, :deleted_at

    add_column :locations, :deleted_at, :datetime
    add_index :locations, :deleted_at

    add_column :communities, :deleted_at, :datetime
    add_index :communities, :deleted_at
  end
end
