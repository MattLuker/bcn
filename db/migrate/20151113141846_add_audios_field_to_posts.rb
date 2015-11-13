class AddAudiosFieldToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :audios, :integer
  end
end
