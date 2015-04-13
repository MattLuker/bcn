class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :post, index: true, foreign_key: true
      t.float :lat
      t.float :lon

      t.timestamps null: false
    end
  end
end
