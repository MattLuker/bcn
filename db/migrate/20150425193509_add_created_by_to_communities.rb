class AddCreatedByToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :created_by, :integer
  end
end
