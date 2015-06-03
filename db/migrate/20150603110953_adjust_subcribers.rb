class AdjustSubcribers < ActiveRecord::Migration
  def change
    drop_table :subscribers

    add_column :posts, :subscribers, :integer, index: true
    add_column :users, :subscriptions, :integer, index: true


    create_table :subscribers do |t|
      t.belongs_to :post, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end

    create_table :subscribers_users do |t|
      t.belongs_to :subscriber, index: true
      t.belongs_to :user, index: true
    end
  end
end
