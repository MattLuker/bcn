class AddGoogleAttrsToUser < ActiveRecord::Migration
  def change
    add_column :users, :google_link, :string
    add_column :users, :google_id, :string, foreign_key: false
    add_column :users, :google_token, :string

    add_index :users, :google_id
  end
end
