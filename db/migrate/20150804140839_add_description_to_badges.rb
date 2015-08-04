class AddDescriptionToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :description, :string
  end
end
