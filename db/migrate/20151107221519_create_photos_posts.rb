class CreatePhotosPosts < ActiveRecord::Migration
  def change
    create_table "photos_posts", force: :cascade do |t|
      t.integer "photo_id", index: {name: "index_photos_posts_on_photo_id"}, foreign_key: {references: "photos", name: "fk_photos_posts_photo_id", on_update: :no_action, on_delete: :no_action}
      t.integer "post_id",  index: {name: "index_photos_posts_on_post_id"}, foreign_key: {references: "posts", name: "fk_photos_posts_post_id", on_update: :no_action, on_delete: :no_action}
    end
  end
end
