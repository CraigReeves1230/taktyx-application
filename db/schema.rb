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

ActiveRecord::Schema.define(version: 20160626184223) do

  create_table "addresses", force: :cascade do |t|
    t.string   "line_1",      limit: 255
    t.string   "line_2",      limit: 255
    t.string   "city",        limit: 255
    t.string   "zip_code",    limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "location_id", limit: 4
  end

  add_index "addresses", ["location_id"], name: "index_addresses_on_location_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "category_id", limit: 4
  end

  add_index "categories", ["category_id"], name: "index_categories_on_category_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "desctription", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "file",         limit: 255
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.string   "address",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "status",     limit: 255
  end

  add_index "ip_addresses", ["address"], name: "index_ip_addresses_on_address", using: :btree

  create_table "locations", force: :cascade do |t|
    t.float    "long",       limit: 24
    t.float    "lat",        limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "locations", ["long", "lat"], name: "index_locations_on_long_and_lat", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "content",      limit: 65535
    t.integer  "sender_id",    limit: 4
    t.integer  "recipient_id", limit: 4
    t.boolean  "is_read",                    default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "messages", ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "description", limit: 255
    t.string   "image",       limit: 255
    t.integer  "user_id",     limit: 4
  end

  add_index "photos", ["user_id"], name: "index_photos_on_user_id", using: :btree

  create_table "rel_user_ip_addresses", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",       limit: 4
    t.integer  "ip_address_id", limit: 4
  end

  add_index "rel_user_ip_addresses", ["ip_address_id"], name: "index_rel_user_ip_addresses_on_ip_address_id", using: :btree
  add_index "rel_user_ip_addresses", ["user_id"], name: "index_rel_user_ip_addresses_on_user_id", using: :btree

  create_table "rel_user_service_favorites", force: :cascade do |t|
    t.integer  "sort_order", limit: 4, default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id",    limit: 4
    t.integer  "service_id", limit: 4
  end

  create_table "rel_user_services", force: :cascade do |t|
    t.integer  "sort_order", limit: 4, default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id",    limit: 4
    t.integer  "service_id", limit: 4
  end

  add_index "rel_user_services", ["service_id"], name: "index_rel_user_services_on_service_id", using: :btree
  add_index "rel_user_services", ["user_id"], name: "index_rel_user_services_on_user_id", using: :btree

  create_table "service_ratings", force: :cascade do |t|
    t.float    "score",      limit: 24,    default: 0.0
    t.text     "comment",    limit: 65535
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "user_id",    limit: 4
    t.integer  "service_id", limit: 4
  end

  add_index "service_ratings", ["service_id"], name: "index_service_ratings_on_service_id", using: :btree
  add_index "service_ratings", ["user_id", "service_id"], name: "index_service_ratings_on_user_id_and_service_id", using: :btree
  add_index "service_ratings", ["user_id"], name: "index_service_ratings_on_user_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.boolean  "is_published",                      default: true
    t.datetime "last_active"
    t.boolean  "is_sharing_allowed",                default: true
    t.boolean  "are_ratings_allowed",               default: true
    t.boolean  "can_receive_takts",                 default: true
    t.string   "status",              limit: 255
    t.text     "description",         limit: 65535
    t.text     "keywords",            limit: 65535
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "category_id",         limit: 4
    t.string   "email",               limit: 255,                   null: false
    t.string   "phone",               limit: 255,                   null: false
    t.integer  "user_id",             limit: 4
    t.integer  "address_id",          limit: 4
    t.boolean  "is_active",                         default: false
  end

  add_index "services", ["address_id"], name: "index_services_on_address_id", using: :btree
  add_index "services", ["category_id"], name: "index_services_on_category_id", using: :btree
  add_index "services", ["is_active"], name: "index_services_on_is_active", using: :btree
  add_index "services", ["user_id"], name: "index_services_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",        limit: 255
    t.string   "last_name",         limit: 255
    t.string   "email",             limit: 255
    t.string   "password_digest",   limit: 255
    t.string   "status",            limit: 255, default: "inactive"
    t.string   "token",             limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "screen_name",       limit: 255
    t.string   "role",              limit: 255, default: "member"
    t.string   "remember_digest",   limit: 255
    t.string   "reset_digest",      limit: 255
    t.datetime "reset_sent_at"
    t.string   "activation_digest", limit: 255
    t.string   "delete_digest",     limit: 255
    t.datetime "delete_sent_at"
    t.integer  "profile_pic",       limit: 4
  end

  add_foreign_key "addresses", "locations"
  add_foreign_key "photos", "users"
  add_foreign_key "rel_user_ip_addresses", "ip_addresses"
  add_foreign_key "rel_user_ip_addresses", "users"
  add_foreign_key "service_ratings", "services"
  add_foreign_key "service_ratings", "users"
  add_foreign_key "services", "addresses"
  add_foreign_key "services", "categories"
  add_foreign_key "services", "users"
end
