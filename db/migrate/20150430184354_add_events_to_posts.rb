class AddEventsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :start_date, :integer
    add_column :posts, :end_date, :integer

    add_index :locations, :name
  end
end
