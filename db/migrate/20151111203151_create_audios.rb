class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.string   "audio", index: true
      t.string   "audio_uid"
      t.string   "audio_name", index: true
      t.integer  "audio_duration"
      t.references :post, index: true

      t.timestamps null: false
    end

    add_reference :posts, :audios, index: true, foreign_key: true
  end
end
