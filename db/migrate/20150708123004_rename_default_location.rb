class RenameDefaultLocation < ActiveRecord::Migration
  def change
    rename_column :communities, :default_location, :location_id
  end
end
