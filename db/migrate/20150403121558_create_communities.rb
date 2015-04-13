class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name
      t.string :description
      t.string :home_page
      t.string :color

      t.timestamps null: false
    end
  end
end
