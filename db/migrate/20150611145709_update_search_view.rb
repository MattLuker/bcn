class UpdateSearchView < ActiveRecord::Migration
  def change
        drop_table :search_views
        drop_view :searches

        create_table :search_views do |t|

          view2 = <<-VIEW2
  SELECT
    posts.id AS searchable_id,
    'Post' AS searchable_type,
    posts.title AS term
  FROM posts

  UNION

  SELECT
    posts.id AS searchable_id,
    'Post' AS searchable_type,
    posts.description AS term
  FROM posts

  UNION

  SELECT
    comments.id AS searchable_id,
    'Comment' AS searchable_type,
    comments.content AS term
  FROM comments

  UNION

  SELECT
    communities.id AS searchable_id,
    'Community' AS searchable_type,
    communities.name AS term
  FROM communities

  UNION

  SELECT
    locations.id AS searchable_id,
    'Location' AS searchable_type,
    locations.name AS term
  FROM locations

  UNION

  SELECT
    users.id AS searchable_id,
    'User' AS searchable_type,
    users.username AS term
  FROM users

  UNION

  SELECT
    users.id AS searchable_id,
    'User' AS searchable_type,
    users.email AS term
  FROM users
          VIEW2

          create_view :searches, view2, force: true

          #CREATE INDEX index_statuses_on_body ON statuses USING gin(to_tsvector('english', body));
          #add_index :posts, :description, using: :gin to_tsvector('english', 'description'))

          remove_index :posts, :title
          remove_index :posts, :description
          remove_index :comments, :content
          remove_index :communities, :name
          remove_index :locations, :name
          remove_index :users, :username
          remove_index :users, :email

          execute %q{create index index_posts_on_title on "posts" using gin(to_tsvector('english', title))}
          execute %q{create index index_posts_on_description on "posts" using gin(to_tsvector('english', description))}
          execute %q{create index index_comments_on_content on "comments" using gin(to_tsvector('english', content))}
          execute %q{create index index_communities_on_name on "communities" using gin(to_tsvector('english', name))}
          execute %q{create index index_locations_on_name on "locations" using gin(to_tsvector('english', name))}
          execute %q{create index index_users_on_username on "users" using gin(to_tsvector('english', username))}
          execute %q{create index index_users_on_email on "users" using gin(to_tsvector('english', email))}


    end
  end
end
