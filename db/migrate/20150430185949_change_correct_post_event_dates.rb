class ChangeCorrectPostEventDates < ActiveRecord::Migration
  def change
    remove_column :posts, :start_date, :integer
    remove_column :posts, :end_date, :integer

    add_column :posts, :start_date, :datetime
    add_column :posts, :end_date, :datetime
  end
end
