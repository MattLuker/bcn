class AddWebLinkToUser < ActiveRecord::Migration
  def change
    add_column :users, :web_link, :string

  end
end
