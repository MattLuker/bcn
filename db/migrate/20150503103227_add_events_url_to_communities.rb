class AddEventsUrlToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :events_url, :string
  end
end
