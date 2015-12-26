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

ActiveRecord::Schema.define(version: 20151223032410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buckets", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buckets", ["region_id"], name: "index_buckets_on_region_id", using: :btree
  add_index "buckets", ["user_id"], name: "index_buckets_on_user_id", using: :btree

  create_table "cloud_files", force: true do |t|
    t.string   "name"
    t.string   "asset"
    t.string   "md5"
    t.string   "content_type"
    t.integer  "filesize",     limit: 8, default: 0
    t.text     "description"
    t.float    "rating"
    t.boolean  "nsfw",                   default: false
    t.boolean  "adult",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "folder_id"
    t.string   "info_url"
    t.integer  "bucket_id"
    t.integer  "duration",               default: 0
  end

  add_index "cloud_files", ["bucket_id"], name: "index_cloud_files_on_bucket_id", using: :btree
  add_index "cloud_files", ["duration"], name: "index_cloud_files_on_duration", using: :btree
  add_index "cloud_files", ["folder_id"], name: "index_cloud_files_on_folder_id", using: :btree

  create_table "folders", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "bucket_id"
  end

  add_index "folders", ["ancestry"], name: "index_folders_on_ancestry", using: :btree
  add_index "folders", ["bucket_id"], name: "index_folders_on_bucket_id", using: :btree

  create_table "regions", force: true do |t|
    t.string   "descr",      null: false
    t.string   "name",       null: false
    t.string   "endpoint",   null: false
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                            default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "encrypted_access_key_id"
    t.string   "encrypted_access_key_id_salt"
    t.string   "encrypted_access_key_id_iv"
    t.string   "encrypted_secret_access_key"
    t.string   "encrypted_secret_access_key_salt"
    t.string   "encrypted_secret_access_key_iv"
    t.string   "token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
