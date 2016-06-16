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

ActiveRecord::Schema.define(version: 20160616042944) do

  create_table "addresses", force: :cascade do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "location_id"
  end

  add_index "addresses", ["location_id"], name: "index_addresses_on_location_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "category_id"
  end

  add_index "categories", ["category_id"], name: "index_categories_on_category_id"

  create_table "ip_addresses", force: :cascade do |t|
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ip_addresses", ["address"], name: "index_ip_addresses_on_address"

  create_table "locations", force: :cascade do |t|
    t.float    "long"
    t.float    "lat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "locations", ["long", "lat"], name: "index_locations_on_long_and_lat"

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "is_read",      default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "messages", ["recipient_id"], name: "index_messages_on_recipient_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "rel_user_ip_addresses", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.integer  "ip_address_id"
  end

  add_index "rel_user_ip_addresses", ["ip_address_id"], name: "index_rel_user_ip_addresses_on_ip_address_id"
  add_index "rel_user_ip_addresses", ["user_id"], name: "index_rel_user_ip_addresses_on_user_id"

  create_table "rel_user_service_favorites", force: :cascade do |t|
    t.integer  "sort_order", default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id"
    t.integer  "service_id"
  end

  create_table "rel_user_services", force: :cascade do |t|
    t.integer  "sort_order", default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id"
    t.integer  "service_id"
  end

  add_index "rel_user_services", ["service_id"], name: "index_rel_user_services_on_service_id"
  add_index "rel_user_services", ["user_id"], name: "index_rel_user_services_on_user_id"

  create_table "service_ratings", force: :cascade do |t|
    t.float    "score",      default: 0.0
    t.text     "comment"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "user_id"
    t.integer  "service_id"
  end

  add_index "service_ratings", ["service_id"], name: "index_service_ratings_on_service_id"
  add_index "service_ratings", ["user_id", "service_id"], name: "index_service_ratings_on_user_id_and_service_id"
  add_index "service_ratings", ["user_id"], name: "index_service_ratings_on_user_id"

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.boolean  "is_active",   default: false
    t.datetime "last_active"
    t.string   "status"
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "category_id"
    t.integer  "address_id"
  end

  add_index "services", ["address_id"], name: "index_services_on_address_id"
  add_index "services", ["category_id"], name: "index_services_on_category_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "status",          default: "active"
    t.string   "token"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "screen_name"
    t.string   "role",            default: "member"
    t.string   "remember_digest"
    t.string   "reset_digest"
  end

end
