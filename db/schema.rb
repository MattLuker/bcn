# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150608205127) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.string   "title",          index: {name: "index_posts_on_title"}
    t.text     "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "communities"
    t.datetime "deleted_at",     index: {name: "index_posts_on_deleted_at"}
    t.integer  "user_id",        index: {name: "index_posts_on_user_id"}
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "image"
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "og_url",         index: {name: "index_posts_on_og_url"}
    t.string   "og_title"
    t.string   "og_image"
    t.string   "og_description"
    t.string   "audio"
    t.string   "audio_uid"
    t.string   "audio_name"
    t.integer  "audio_duration"
    t.boolean  "explicit"
    t.index name: "index_posts_on_description", using: :gin, expression: "to_tsvector('english'::regconfig, description)"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "username"
    t.string   "password_reset_token", index: {name: "index_users_on_password_reset_token"}
    t.integer  "communities"
    t.datetime "deleted_at",           index: {name: "index_users_on_deleted_at"}
    t.string   "facebook_id",          index: {name: "index_users_on_facebook_id"}
    t.string   "photo"
    t.time     "event_sync_time"
    t.string   "merge_token",          index: {name: "index_users_on_merge_token"}
    t.string   "twitter_id",           index: {name: "index_users_on_twitter_id"}
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.string   "twitter_link"
    t.string   "facebook_link"
    t.string   "google_link"
    t.string   "google_id",            index: {name: "index_users_on_google_id"}
    t.string   "google_token"
    t.string   "web_link"
    t.string   "photo_uid"
    t.string   "photo_name"
    t.string   "role",                 index: {name: "index_users_on_role"}
    t.index name: "index_users_on_email", using: :gin, expression: "to_tsvector('english'::regconfig, (email)::text)"
    t.index name: "index_users_on_username", using: :gin, expression: "to_tsvector('english'::regconfig, (username)::text)"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.string   "photo_uid"
    t.string   "photo_name"
    t.integer  "user_id",    index: {name: "index_comments_on_user_id"}, foreign_key: {references: "users", name: "fk_rails_03de2dc08c", on_update: :no_action, on_delete: :no_action}
    t.integer  "post_id",    index: {name: "index_comments_on_post_id"}, foreign_key: {references: "posts", name: "fk_rails_2fd19c0db7", on_update: :no_action, on_delete: :no_action}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", index: {name: "index_comments_on_deleted_at"}
    t.integer  "parent_id"
    t.index name: "index_comments_on_content", using: :gin, expression: "to_tsvector('english'::regconfig, content)"
  end

  create_table "communities", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "home_page"
    t.string   "color"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "posts"
    t.datetime "deleted_at",       index: {name: "index_communities_on_deleted_at"}
    t.integer  "users"
    t.integer  "created_by",       foreign_key: {references: "users", name: "fk_rails_3fb6963f4b", on_update: :no_action, on_delete: :no_action}
    t.string   "events_url"
    t.string   "events_sync_type", index: {name: "index_communities_on_events_sync_type"}
    t.string   "image"
    t.string   "image_uid"
    t.string   "image_name"
    t.boolean  "explicit"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "google_link"
    t.index name: "index_communities_on_name", using: :gin, expression: "to_tsvector('english'::regconfig, (name)::text)"
  end

  create_table "communities_posts", id: false, force: :cascade do |t|
    t.integer "post_id",      index: {name: "index_communities_posts_on_post_id"}
    t.integer "community_id", index: {name: "index_communities_posts_on_community_id"}
  end

  create_table "communities_users", force: :cascade do |t|
    t.integer "community_id", index: {name: "index_communities_users_on_community_id"}
    t.integer "user_id",      index: {name: "index_communities_users_on_user_id"}
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "post_id",    index: {name: "index_locations_on_post_id"}, foreign_key: {references: "posts", name: "fk_rails_d5678e2098", on_update: :no_action, on_delete: :no_action}
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postcode"
    t.string   "county"
    t.string   "country"
    t.datetime "deleted_at", index: {name: "index_locations_on_deleted_at"}
    t.index name: "index_locations_on_name", using: :gin, expression: "to_tsvector('english'::regconfig, (name)::text)"
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "post_id",      index: {name: "index_logs_on_post_id"}, foreign_key: {references: "posts", name: "fk_rails_79e6782e3b", on_update: :no_action, on_delete: :no_action}
    t.integer  "location_id",  index: {name: "index_logs_on_location_id"}, foreign_key: {references: "locations", name: "fk_rails_526e01d2ef", on_update: :no_action, on_delete: :no_action}
    t.integer  "community_id", index: {name: "index_logs_on_community_id"}, foreign_key: {references: "communities", name: "fk_rails_a6f7ddf4ba", on_update: :no_action, on_delete: :no_action}
    t.string   "action"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
  end

  create_table "search_views", force: :cascade do |t|
  end

  create_view "searches", " SELECT posts.id AS searchable_id,\n    'Post'::text AS searchable_type,\n    comments.content AS term\n   FROM (posts\n     JOIN comments ON ((posts.id = comments.post_id)))\nUNION\n SELECT comments.id AS searchable_id,\n    'Comment'::text AS searchable_type,\n    comments.content AS term\n   FROM comments\nUNION\n SELECT posts.id AS searchable_id,\n    'Post'::text AS searchable_type,\n    posts.description AS term\n   FROM posts\nUNION\n SELECT communities.id AS searchable_id,\n    'Community'::text AS searchable_type,\n    communities.name AS term\n   FROM communities\nUNION\n SELECT locations.id AS searchable_id,\n    'Location'::text AS searchable_type,\n    locations.name AS term\n   FROM locations\nUNION\n SELECT users.id AS searchable_id,\n    'User'::text AS searchable_type,\n    users.username AS term\n   FROM users\nUNION\n SELECT users.id AS searchable_id,\n    'User'::text AS searchable_type,\n    users.email AS term\n   FROM users", :force => true
  create_table "subscribers", force: :cascade do |t|
    t.integer  "post_id",    index: {name: "index_subscribers_on_post_id"}, foreign_key: {references: "posts", name: "fk_subscribers_post_id", on_update: :no_action, on_delete: :no_action}
    t.integer  "user_id",    index: {name: "index_subscribers_on_user_id"}, foreign_key: {references: "users", name: "fk_subscribers_user_id", on_update: :no_action, on_delete: :no_action}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
