class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string   "image", index: true
      t.string   "image_uid"
      t.string   "image_name", index: true

      t.timestamps null: false
    end
  end
end
