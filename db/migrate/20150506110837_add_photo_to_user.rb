class AddPhotoToUser < ActiveRecord::Migration
  def change
    remove_column :users, :facebook_id, :integer
    add_column :users, :facebook_id, :string, foreign_key: false

    add_column :users, :photo, :string
  end
end
