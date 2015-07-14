class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, index: true
      t.string :email, index: true
      t.string :password_digest
      t.string :password_reset_token, index: true
      t.string :description
      t.string :web_url
      t.string :events_url
      t.string :facebook_link
      t.string :twitter_link
      t.string :google_link
      t.string :color
      t.integer :location_id
      t.string :image
      t.string :image_uid
      t.string :image_name
      t.boolean :explicit
      t.string :slug, index: true
      t.integer :created_by, index: true
      t.integer :communities
      t.integer :users
      t.integer :posts
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end

    create_table :communities_organizations do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :community, index: true
    end

    create_table :organizations_users do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :user, index: true
    end

    create_table :organizations_posts do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :post, index: true
    end

    add_column :users, :organizations, :integer
    add_column :posts, :organizations, :integer
    add_column :communities, :organizations, :integer
    add_column :subscribers, :organization_id, :integer
    add_column :subscribers, :type, :string
    add_column :facebook_subscriptions, :organization_id, :integer
    add_column :locations, :organization_id, :integer
    add_column :comments, :organization_id, :integer

  end
end
