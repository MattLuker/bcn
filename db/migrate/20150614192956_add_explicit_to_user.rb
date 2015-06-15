class AddExplicitToUser < ActiveRecord::Migration
  def change
    add_column :users, :explicit, :boolean
  end
end
