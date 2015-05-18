class AddMergeTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :merge_token, :string
    add_index :users, :merge_token
  end
end
