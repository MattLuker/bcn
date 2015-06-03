class CleanUpSubscribers < ActiveRecord::Migration
  def change
    remove_column :posts, :subscribers, :integer, index: true
    remove_column :users, :subscriptions, :integer, index: true

    drop_table :subscribers_users
  end
end
