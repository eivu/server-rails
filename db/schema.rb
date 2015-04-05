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

ActiveRecord::Schema.define(version: 20150405045049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cloud_files", force: true do |t|
    t.string   "name"
    t.string   "asset"
    t.string   "md5"
    t.string   "content_type"
    t.integer  "filesize",     default: 0
    t.text     "description"
    t.float    "rating"
    t.boolean  "nsfw",         default: false
    t.boolean  "adult",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "folder_id"
  end

  add_index "cloud_files", ["folder_id"], name: "index_cloud_files_on_folder_id", using: :btree

  create_table "folders", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "folders", ["parent_id"], name: "index_folders_on_parent_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
