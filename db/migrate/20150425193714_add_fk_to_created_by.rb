class AddFkToCreatedBy < ActiveRecord::Migration
  def change
    add_foreign_key :communities, :users, column: :created_by
  end
end
