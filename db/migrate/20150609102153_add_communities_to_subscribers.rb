class AddCommunitiesToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :community_id, :integer
    #add_foreign_key :subscribers, :communities
  end
end
