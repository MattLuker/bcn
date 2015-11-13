class FixPostAudios < ActiveRecord::Migration
  def change
    remove_column :posts, :audios_id

    create_table "audios_posts", force: :cascade do |t|
      t.integer "audio_id", index: {name: "index_audios_posts_on_audio_id"}, foreign_key: {references: "audios", name: "fk_audios_posts_audio_id", on_update: :no_action, on_delete: :no_action}
      t.integer "post_id",  index: {name: "index_audios_posts_on_post_id"}, foreign_key: {references: "posts", name: "fk_audios_posts_post_id", on_update: :no_action, on_delete: :no_action}
    end
  end
end
