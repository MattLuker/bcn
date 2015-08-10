class AdditoinalNotificationToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :notification
    add_column :users, :notify_instant, :boolean
    add_column :users, :notify_daily, :boolean
    add_column :users, :notify_weekly, :boolean
  end
end
