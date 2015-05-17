class AddEventSyncTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :event_sync_time, :time
  end
end
