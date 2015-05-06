class AddPhotoToUser < ActiveRecord::Migration
  def change
    remove_column :users, :facebook_id, :integer
    add_column :users, :facebook_id, :string

    add_column :users, :photo, :string
  end
end
