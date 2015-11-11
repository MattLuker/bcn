class AddPhotosToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :photos, :integer
  end
end
