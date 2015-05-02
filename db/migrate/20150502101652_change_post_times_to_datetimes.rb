class ChangePostTimesToDatetimes < ActiveRecord::Migration
  def change
    remove_column :posts, :start_time, :time
    remove_column :posts, :end_time, :time

    add_column :posts, :start_time, :datetime
    add_column :posts, :end_time, :datetime
  end
end
