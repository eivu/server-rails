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

ActiveRecord::Schema.define(version: 20190116171344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artist_cloud_files", force: :cascade do |t|
    t.integer  "artist_id"
    t.integer  "cloud_file_id"
    t.integer  "relationship_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["artist_id"], name: "index_artist_cloud_files_on_artist_id", using: :btree
    t.index ["cloud_file_id"], name: "index_artist_cloud_files_on_cloud_file_id", using: :btree
  end

  create_table "artist_releases", force: :cascade do |t|
    t.integer  "artist_id"
    t.integer  "release_id"
    t.integer  "relationship_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["artist_id"], name: "index_artist_releases_on_artist_id", using: :btree
    t.index ["release_id"], name: "index_artist_releases_on_release_id", using: :btree
  end

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.string   "ext_id"
    t.integer  "data_source_id"
    t.integer  "cloud_files_count", default: 0, null: false
    t.integer  "releases_count",    default: 0, null: false
    t.integer  "video_files_count", default: 0, null: false
    t.integer  "audio_files_count", default: 0, null: false
    t.integer  "peep_files_count",  default: 0, null: false
    t.integer  "misc_files_count",  default: 0, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["audio_files_count"], name: "index_artists_on_audio_files_count", using: :btree
    t.index ["cloud_files_count"], name: "index_artists_on_cloud_files_count", using: :btree
    t.index ["data_source_id"], name: "index_artists_on_data_source_id", using: :btree
    t.index ["ext_id", "data_source_id"], name: "index_artists_on_ext_id_and_data_source_id", using: :btree
    t.index ["ext_id"], name: "index_artists_on_ext_id", using: :btree
    t.index ["misc_files_count"], name: "index_artists_on_misc_files_count", using: :btree
    t.index ["peep_files_count"], name: "index_artists_on_peep_files_count", using: :btree
    t.index ["releases_count"], name: "index_artists_on_releases_count", using: :btree
    t.index ["video_files_count"], name: "index_artists_on_video_files_count", using: :btree
  end

  create_table "buckets", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["region_id"], name: "index_buckets_on_region_id", using: :btree
    t.index ["user_id"], name: "index_buckets_on_user_id", using: :btree
  end

  create_table "cloud_file_taggings", force: :cascade do |t|
    t.integer  "cloud_file_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cloud_file_id"], name: "index_cloud_file_taggings_on_cloud_file_id", using: :btree
    t.index ["tag_id"], name: "index_cloud_file_taggings_on_tag_id", using: :btree
  end

  create_table "cloud_files", force: :cascade do |t|
    t.string   "name"
    t.string   "asset"
    t.string   "md5"
    t.string   "content_type"
    t.bigint   "filesize",       default: 0
    t.text     "description"
    t.float    "rating"
    t.boolean  "nsfw",           default: false
    t.boolean  "peepy",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "folder_id"
    t.string   "info_url"
    t.integer  "bucket_id"
    t.integer  "duration",       default: 0
    t.integer  "settings",       default: 0,     null: false
    t.string   "ext_id"
    t.integer  "data_source_id"
    t.integer  "release_id"
    t.integer  "year"
    t.integer  "release_pos"
    t.integer  "user_id"
    t.index ["bucket_id"], name: "index_cloud_files_on_bucket_id", using: :btree
    t.index ["data_source_id"], name: "index_cloud_files_on_data_source_id", using: :btree
    t.index ["duration"], name: "index_cloud_files_on_duration", using: :btree
    t.index ["ext_id", "data_source_id"], name: "index_cloud_files_on_ext_id_and_data_source_id", using: :btree
    t.index ["ext_id"], name: "index_cloud_files_on_ext_id", using: :btree
    t.index ["folder_id"], name: "index_cloud_files_on_folder_id", using: :btree
    t.index ["release_id"], name: "index_cloud_files_on_release_id", using: :btree
    t.index ["user_id"], name: "index_cloud_files_on_user_id", using: :btree
    t.index ["year"], name: "index_cloud_files_on_year", using: :btree
  end

  create_table "folders", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "bucket_id"
    t.boolean  "peepy",      default: false, null: false
    t.boolean  "nsfw",       default: false, null: false
    t.index ["ancestry"], name: "index_folders_on_ancestry", using: :btree
    t.index ["bucket_id"], name: "index_folders_on_bucket_id", using: :btree
  end

  create_table "metadata", force: :cascade do |t|
    t.string   "value"
    t.integer  "user_id"
    t.integer  "metadata_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["metadata_type_id"], name: "index_metadata_on_metadata_type_id", using: :btree
    t.index ["user_id"], name: "index_metadata_on_user_id", using: :btree
  end

  create_table "metadata_types", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metataggings", force: :cascade do |t|
    t.integer  "cloud_file_id"
    t.integer  "metadatum_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["cloud_file_id"], name: "index_metataggings_on_cloud_file_id", using: :btree
    t.index ["metadatum_id"], name: "index_metataggings_on_metadatum_id", using: :btree
  end

  create_table "regions", force: :cascade do |t|
    t.string   "descr",      null: false
    t.string   "name",       null: false
    t.string   "endpoint",   null: false
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "release_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "releases", force: :cascade do |t|
    t.string   "name"
    t.string   "ext_id"
    t.integer  "data_source_id"
    t.integer  "cloud_files_count", default: 0,     null: false
    t.integer  "release_type_id"
    t.integer  "bundle_pos",        default: 1
    t.boolean  "peepy",             default: false
    t.boolean  "nsfw",              default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["cloud_files_count"], name: "index_releases_on_cloud_files_count", using: :btree
    t.index ["data_source_id"], name: "index_releases_on_data_source_id", using: :btree
    t.index ["ext_id", "data_source_id"], name: "index_releases_on_ext_id_and_data_source_id", using: :btree
    t.index ["ext_id"], name: "index_releases_on_ext_id", using: :btree
    t.index ["release_type_id"], name: "index_releases_on_release_type_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "value"
    t.integer  "user_id"
    t.boolean  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_tags_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
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
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "artist_cloud_files", "artists"
  add_foreign_key "artist_cloud_files", "cloud_files"
  add_foreign_key "artist_releases", "artists"
  add_foreign_key "artist_releases", "releases"
end