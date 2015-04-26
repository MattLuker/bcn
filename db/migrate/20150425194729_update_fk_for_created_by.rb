class UpdateFkForCreatedBy < ActiveRecord::Migration
  def change
    remove_foreign_key :communities, column: :created_by
    add_foreign_key :communities, :users, column: :created_by, primary_key: "id"
  end
end
