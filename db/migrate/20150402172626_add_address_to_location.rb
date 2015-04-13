class AddAddressToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :name, :string
    add_column :locations, :address, :string
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :postcode, :string
    add_column :locations, :county, :string
    add_column :locations, :country, :string
  end
end
