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

ActiveRecord::Schema.define(version: 20151123152206) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "communities"
    t.datetime "deleted_at",      index: {name: "index_posts_on_deleted_at"}
    t.integer  "user_id",         index: {name: "index_posts_on_user_id"}
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "image"
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "og_url",          index: {name: "index_posts_on_og_url"}
    t.string   "og_title"
    t.string   "og_image"
    t.string   "og_description"
    t.string   "audio"
    t.string   "audio_uid"
    t.string   "audio_name"
    t.integer  "audio_duration"
    t.boolean  "explicit"
    t.integer  "organization_id"
    t.integer  "locations"
    t.integer  "photos"
    t.integer  "audios"
    t.index name: "index_posts_on_description", using: :gin, expression: "to_tsvector('english'::regconfig, description)"
    t.index name: "index_posts_on_title", using: :gin, expression: "to_tsvector('english'::regconfig, (title)::text)"
  end

  create_table "audios", force: :cascade do |t|
    t.string   "audio",          index: {name: "index_audios_on_audio"}
    t.string   "audio_uid"
    t.string   "audio_name",     index: {name: "index_audios_on_audio_name"}
    t.integer  "audio_duration"
    t.integer  "post_id",        index: {name: "index_audios_on_post_id"}, foreign_key: {references: "posts", name: "fk_audios_post_id", on_update: :no_action, on_delete: :no_action}
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "audios_posts", force: :cascade do |t|
    t.integer "audio_id", index: {name: "index_audios_posts_on_audio_id"}, foreign_key: {references: "audios", name: "fk_audios_posts_audio_id", on_update: :no_action, on_delete: :no_action}
    t.integer "post_id",  index: {name: "index_audios_posts_on_post_id"}, foreign_key: {references: "posts", name: "fk_audios_posts_post_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "badges", force: :cascade do |t|
    t.string   "name",        index: {name: "index_badges_on_name"}
    t.string   "rules"
    t.string   "image"
    t.string   "image_uid"
    t.string   "image_name"
    t.integer  "users"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
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
    t.boolean  "explicit"
    t.string   "facebook_token"
    t.string   "bio"
    t.integer  "organizations"
    t.integer  "badges"
    t.boolean  "notify_instant"
    t.boolean  "notify_daily"
    t.boolean  "notify_weekly"
    t.index name: "index_users_on_email", using: :gin, expression: "to_tsvector('english'::regconfig, (email)::text)"
    t.index name: "index_users_on_username", using: :gin, expression: "to_tsvector('english'::regconfig, (username)::text)"
  end

  create_table "badges_users", force: :cascade do |t|
    t.integer "badge_id", index: {name: "index_badges_users_on_badge_id"}, foreign_key: {references: "badges", name: "fk_badges_users_badge_id", on_update: :no_action, on_delete: :no_action}
    t.integer "user_id",  index: {name: "index_badges_users_on_user_id"}, foreign_key: {references: "users", name: "fk_badges_users_user_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                 index: {name: "index_organizations_on_name"}
    t.string   "email",                index: {name: "index_organizations_on_email"}
    t.string   "password_digest"
    t.string   "password_reset_token", index: {name: "index_organizations_on_password_reset_token"}
    t.string   "description"
    t.string   "web_url"
    t.string   "events_url"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "google_link"
    t.string   "color"
    t.integer  "location_id",          index: {name: "fk__organizations_location_id"} # foreign key references "locations" (below)
    t.string   "image"
    t.string   "image_uid"
    t.string   "image_name"
    t.boolean  "explicit"
    t.string   "slug",                 index: {name: "index_organizations_on_slug"}
    t.integer  "created_by",           index: {name: "index_organizations_on_created_by"}
    t.integer  "communities"
    t.integer  "users"
    t.integer  "posts"
    t.datetime "deleted_at",           index: {name: "index_organizations_on_deleted_at"}
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "facebook_group"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.string   "photo_uid"
    t.string   "photo_name"
    t.integer  "user_id",         index: {name: "index_comments_on_user_id"}, foreign_key: {references: "users", name: "fk_rails_03de2dc08c", on_update: :no_action, on_delete: :no_action}
    t.integer  "post_id",         index: {name: "index_comments_on_post_id"}, foreign_key: {references: "posts", name: "fk_rails_2fd19c0db7", on_update: :no_action, on_delete: :no_action}
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at",      index: {name: "index_comments_on_deleted_at"}
    t.integer  "parent_id"
    t.integer  "organization_id", index: {name: "fk__comments_organization_id"}, foreign_key: {references: "organizations", name: "fk_comments_organization_id", on_update: :no_action, on_delete: :no_action}
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
    t.string   "slug",             index: {name: "index_communities_on_slug"}
    t.integer  "location_id"
    t.integer  "organizations"
    t.index name: "index_communities_on_name", using: :gin, expression: "to_tsvector('english'::regconfig, (name)::text)"
  end

  create_table "communities_organizations", force: :cascade do |t|
    t.integer "organization_id", index: {name: "index_communities_organizations_on_organization_id"}, foreign_key: {references: "organizations", name: "fk_communities_organizations_organization_id", on_update: :no_action, on_delete: :no_action}
    t.integer "community_id",    index: {name: "index_communities_organizations_on_community_id"}, foreign_key: {references: "communities", name: "fk_communities_organizations_community_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "communities_posts", id: false, force: :cascade do |t|
    t.integer "post_id",      index: {name: "index_communities_posts_on_post_id"}
    t.integer "community_id", index: {name: "index_communities_posts_on_community_id"}
  end

  create_table "communities_users", force: :cascade do |t|
    t.integer "community_id", index: {name: "index_communities_users_on_community_id"}
    t.integer "user_id",      index: {name: "index_communities_users_on_user_id"}
  end

  create_table "facebook_subscriptions", force: :cascade do |t|
    t.string   "verify_token"
    t.integer  "user_id",         index: {name: "index_facebook_subscriptions_on_user_id"}, foreign_key: {references: "users", name: "fk_facebook_subscriptions_user_id", on_update: :no_action, on_delete: :no_action}
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id", index: {name: "fk__facebook_subscriptions_organization_id"}, foreign_key: {references: "organizations", name: "fk_facebook_subscriptions_organization_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "locations", force: :cascade do |t|
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postcode"
    t.string   "county"
    t.string   "country"
    t.datetime "deleted_at",      index: {name: "index_locations_on_deleted_at"}
    t.integer  "community_id",    index: {name: "fk__locations_community_id"}, foreign_key: {references: "communities", name: "fk_locations_community_id", on_update: :no_action, on_delete: :no_action}
    t.integer  "organization_id", index: {name: "fk__locations_organization_id"}, foreign_key: {references: "organizations", name: "fk_locations_organization_id", on_update: :no_action, on_delete: :no_action}
    t.integer  "posts"
    t.index name: "index_locations_on_name", using: :gin, expression: "to_tsvector('english'::regconfig, (name)::text)"
  end
  add_foreign_key "organizations", "locations", column: "location_id", name: "fk_organizations_location_id", on_update: :no_action, on_delete: :no_action

  create_table "locations_posts", id: false, force: :cascade do |t|
    t.integer "post_id",     index: {name: "index_locations_posts_on_post_id"}, foreign_key: {references: "posts", name: "fk_locations_posts_post_id", on_update: :no_action, on_delete: :no_action}
    t.integer "location_id", index: {name: "index_locations_posts_on_location_id"}, foreign_key: {references: "locations", name: "fk_locations_posts_location_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "organizations_posts", force: :cascade do |t|
    t.integer "organization_id", index: {name: "index_organizations_posts_on_organization_id"}, foreign_key: {references: "organizations", name: "fk_organizations_posts_organization_id", on_update: :no_action, on_delete: :no_action}
    t.integer "post_id",         index: {name: "index_organizations_posts_on_post_id"}, foreign_key: {references: "posts", name: "fk_organizations_posts_post_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "roles", force: :cascade do |t|
    t.string  "name",            index: {name: "index_roles_on_name"}
    t.integer "user_id",         index: {name: "fk__roles_user_id"}, foreign_key: {references: "users", name: "fk_roles_user_id", on_update: :no_action, on_delete: :no_action}
    t.integer "organization_id", index: {name: "fk__roles_organization_id"}, foreign_key: {references: "organizations", name: "fk_roles_organization_id", on_update: :no_action, on_delete: :no_action}
  end
  add_index "roles", ["organization_id"], name: "index_roles_on_organization_id"
  add_index "roles", ["user_id"], name: "index_roles_on_user_id"

  create_table "organizations_roles", force: :cascade do |t|
    t.integer "role_id",         index: {name: "index_organizations_roles_on_role_id"}, foreign_key: {references: "roles", name: "fk_organizations_roles_role_id", on_update: :no_action, on_delete: :no_action}
    t.integer "organization_id", index: {name: "index_organizations_roles_on_organization_id"}, foreign_key: {references: "organizations", name: "fk_organizations_roles_organization_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "organizations_users", force: :cascade do |t|
    t.integer "organization_id", index: {name: "index_organizations_users_on_organization_id"}, foreign_key: {references: "organizations", name: "fk_organizations_users_organization_id", on_update: :no_action, on_delete: :no_action}
    t.integer "user_id",         index: {name: "index_organizations_users_on_user_id"}, foreign_key: {references: "users", name: "fk_organizations_users_user_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "photos", force: :cascade do |t|
    t.string   "image",      index: {name: "index_photos_on_image"}
    t.string   "image_uid"
    t.string   "image_name", index: {name: "index_photos_on_image_name"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "post_id",    index: {name: "index_photos_on_post_id"}, foreign_key: {references: "posts", name: "fk_photos_post_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "photos_posts", force: :cascade do |t|
    t.integer "photo_id", index: {name: "index_photos_posts_on_photo_id"}, foreign_key: {references: "photos", name: "fk_photos_posts_photo_id", on_update: :no_action, on_delete: :no_action}
    t.integer "post_id",  index: {name: "index_photos_posts_on_post_id"}, foreign_key: {references: "posts", name: "fk_photos_posts_post_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "roles_users", force: :cascade do |t|
    t.integer "role_id", index: {name: "index_roles_users_on_role_id"}, foreign_key: {references: "roles", name: "fk_roles_users_role_id", on_update: :no_action, on_delete: :no_action}
    t.integer "user_id", index: {name: "index_roles_users_on_user_id"}, foreign_key: {references: "users", name: "fk_roles_users_user_id", on_update: :no_action, on_delete: :no_action}
  end

  create_table "search_views", force: :cascade do |t|
  end

  create_view "searches", <<-'END_VIEW_SEARCHES', :force => true
 SELECT posts.id AS searchable_id,
    'Post'::text AS searchable_type,
    posts.title AS term
   FROM posts
UNION
 SELECT posts.id AS searchable_id,
    'Post'::text AS searchable_type,
    posts.description AS term
   FROM posts
UNION
 SELECT comments.id AS searchable_id,
    'Comment'::text AS searchable_type,
    comments.content AS term
   FROM comments
UNION
 SELECT communities.id AS searchable_id,
    'Community'::text AS searchable_type,
    communities.name AS term
   FROM communities
UNION
 SELECT locations.id AS searchable_id,
    'Location'::text AS searchable_type,
    locations.name AS term
   FROM locations
UNION
 SELECT users.id AS searchable_id,
    'User'::text AS searchable_type,
    users.username AS term
   FROM users
UNION
 SELECT users.id AS searchable_id,
    'User'::text AS searchable_type,
    users.email AS term
   FROM users
  END_VIEW_SEARCHES

  create_table "subscribers", force: :cascade do |t|
    t.integer  "post_id",         index: {name: "index_subscribers_on_post_id"}, foreign_key: {references: "posts", name: "fk_subscribers_post_id", on_update: :no_action, on_delete: :no_action}
    t.integer  "user_id",         index: {name: "index_subscribers_on_user_id"}, foreign_key: {references: "users", name: "fk_subscribers_user_id", on_update: :no_action, on_delete: :no_action}
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "community_id",    index: {name: "fk__subscribers_community_id"}, foreign_key: {references: "communities", name: "fk_subscribers_community_id", on_update: :no_action, on_delete: :no_action}
    t.integer  "organization_id", index: {name: "fk__subscribers_organization_id"}, foreign_key: {references: "organizations", name: "fk_subscribers_organization_id", on_update: :no_action, on_delete: :no_action}
    t.string   "type"
  end

end
