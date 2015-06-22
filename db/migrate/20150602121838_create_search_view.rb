class CreateSearchView < ActiveRecord::Migration
  def change
    create_table :search_views do |t|

      view = <<-VIEW
          CREATE VIEW searches AS

  SELECT
    posts.id AS searchable_id,
    posts.description AS searchable_post_description,
    posts.image_name as searchable_post_image_name,
    posts.start_date as searchable_post_start_date,
    posts.end_date as searchable_post_end_date,
    posts.start_time as searchable_post_start_time,
    posts.end_time as searchable_post_end_time,
    posts.created_at as searchable_post_created_at,

    comments.content AS searchable_comment_content,
    comments.photo_name as searchable_comment_photo_name,
    comments.created_at as searchable_comment_created_at,

    users.username as searchable_username,
    users.first_name as searchable_first_name,
    users.last_name as searchable_last_name,
    users.email as searchable_email,
    users.web_link as searchable_user_web_link,
    users.facebook_link as searchable_user_facebook_link,
    users.google_link as searchable_user_google_link,
    users.twitter_link as searchable_twitter_link,
    users.photo_name as searchable_user_photo_name,
    users.created_at as searchable_user_created_at,

    locations.lat as searchable_lat,
    locations.lon as searchable_lon,
    locations.name as searchable_location_name,
    locations.address as searchable_location_address,

    communities.name as searchable_community_name,
    communities.description as searchable_community_description,
    communities.home_page as searchable_community_home_page,
    communities.created_at as searchable_community_created_at


  FROM posts
  JOIN comments ON statuses.id = comments.status_id

  UNION

  SELECT
    statuses.id AS searchable_id,
    'Status' AS searchable_type,
    statuses.body AS term
  FROM statuses

  UNION

  SELECT
    users.id AS searchable_id,
    'User' AS searchable_type,
    users.name AS term
  FROM users
VIEW
      #SELECT
      #posts.id AS searchable_id,
      #            'Post' AS searchable_type,
      #                      comments.content AS term
      #FROM posts
      #JOIN comments ON posts.id = comments.post_id
      #
      #UNION
      #
      #SELECT
      #posts.id AS searchable_id,
      #            'Post' AS searchable_type,
      #                      comments.content AS term
      #FROM posts
      #JOIN comments ON posts.id = comments.post_id
      #
      #UNION

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

      remove_index :communities, :name
      remove_index :locations, :name
      remove_index :users, :username
      remove_index :users, :email
      remove_index :posts, :title

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
