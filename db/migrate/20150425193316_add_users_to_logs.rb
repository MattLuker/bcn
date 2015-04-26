class AddUsersToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :user_id, :integer
  end
end
