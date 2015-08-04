class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :name, index: true
      t.string :rules
      t.string :image
      t.string :image_uid
      t.string :image_name
      t.integer :users

      t.timestamps null: false
    end

    add_column :users, :badges, :integer
  end
end
