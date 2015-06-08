class AddSocialLinksToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :facebook_link, :string
    add_column :communities, :twitter_link, :string
    add_column :communities, :google_link, :string

  end
end
