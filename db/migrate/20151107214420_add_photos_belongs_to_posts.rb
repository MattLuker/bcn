class AddPhotosBelongsToPosts < ActiveRecord::Migration
  def change
    remove_column :photos, :post_id
    add_reference :photos, :post, index: true, foreign_key: true
  end
end
