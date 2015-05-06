class AddFacebookIdIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :facebook_id
  end
end
