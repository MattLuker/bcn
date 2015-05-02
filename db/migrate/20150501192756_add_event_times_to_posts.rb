class AddEventTimesToPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :start_date, :datetime
    remove_column :posts, :end_date, :datetime

    add_column :posts, :start_date, :date
    add_column :posts, :end_date, :date

    add_column :posts, :start_time, :time
    add_column :posts, :end_time, :time
  end
end