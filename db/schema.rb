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

ActiveRecord::Schema.define(version: 20150415171624) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "communities", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "home_page"
    t.string   "color"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "posts"
    t.datetime "deleted_at"
  end

  add_index "communities", ["deleted_at"], name: "index_communities_on_deleted_at", using: :btree
  add_index "communities", ["name"], name: "index_communities_on_name", unique: true, using: :btree

  create_table "communities_posts", id: false, force: :cascade do |t|
    t.integer "post_id"
    t.integer "community_id"
  end

  add_index "communities_posts", ["community_id"], name: "index_communities_posts_on_community_id", using: :btree
  add_index "communities_posts", ["post_id"], name: "index_communities_posts_on_post_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "post_id"
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
    t.datetime "deleted_at"
  end

  add_index "locations", ["deleted_at"], name: "index_locations_on_deleted_at", using: :btree
  add_index "locations", ["post_id"], name: "index_locations_on_post_id", using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "location_id"
    t.integer  "community_id"
    t.string   "action"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "logs", ["community_id"], name: "index_logs_on_community_id", using: :btree
  add_index "logs", ["location_id"], name: "index_logs_on_location_id", using: :btree
  add_index "logs", ["post_id"], name: "index_logs_on_post_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "communities"
    t.datetime "deleted_at"
  end

  add_index "posts", ["deleted_at"], name: "index_posts_on_deleted_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "locations", "posts"
  add_foreign_key "logs", "communities"
  add_foreign_key "logs", "locations"
  add_foreign_key "logs", "posts"
end
