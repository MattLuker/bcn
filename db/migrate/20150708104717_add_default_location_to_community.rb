class AddDefaultLocationToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :default_location, :integer
  end
end