class AddFbIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_id, :integer, foreign_key: false
    add_index :users, :facebook_id
  end
end
