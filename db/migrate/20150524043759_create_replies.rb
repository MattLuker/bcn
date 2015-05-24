class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|

      t.text :content
      t.string :photo_uid
      t.string :photo_name
      t.datetime :deleted_at, index: true

      t.references :user, index: true, foreign_key: true
      t.references :comment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
