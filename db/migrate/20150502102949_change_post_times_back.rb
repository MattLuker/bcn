class ChangePostTimesBack < ActiveRecord::Migration
  def change
    remove_column :posts, :start_time, :datetime
    remove_column :posts, :end_time, :datetime

    add_column :posts, :start_time, :time
    add_column :posts, :end_time, :time
  end
end
