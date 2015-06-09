class AddCountersToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :posts_count, :integer, default: 0
    add_column :communities, :users_count, :integer, default: 0

  end
end
