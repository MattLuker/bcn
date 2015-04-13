class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.references :post, index: true, foreign_key: true
      t.references :location, index: true, foreign_key: true
      t.references :community, index: true, foreign_key: true
      t.string :action

      t.timestamps null: false
    end
  end
end
