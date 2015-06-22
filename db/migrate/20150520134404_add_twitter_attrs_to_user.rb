class AddTwitterAttrsToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_id, :string, foreign_key: false
    add_column :users, :twitter_token, :string
    add_column :users, :twitter_secret, :string
  end
end
