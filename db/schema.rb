# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_04_23_235431) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artist_cloud_files", id: :serial, force: :cascade do |t|
    t.integer "artist_id"
    t.integer "cloud_file_id"
    t.integer "relationship_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["artist_id"], name: "index_artist_cloud_files_on_artist_id"
    t.index ["cloud_file_id"], name: "index_artist_cloud_files_on_cloud_file_id"
  end

  create_table "artist_releases", id: :serial, force: :cascade do |t|
    t.integer "artist_id"
    t.integer "release_id"
    t.integer "relationship_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["artist_id"], name: "index_artist_releases_on_artist_id"
    t.index ["release_id"], name: "index_artist_releases_on_release_id"
  end

  create_table "artists", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "ext_id"
    t.integer "data_source_id"
    t.integer "cloud_files_count", default: 0, null: false
    t.integer "releases_count", default: 0, null: false
    t.integer "video_files_count", default: 0, null: false
    t.integer "audio_files_count", default: 0, null: false
    t.integer "peep_files_count", default: 0, null: false
    t.integer "misc_files_count", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["audio_files_count"], name: "index_artists_on_audio_files_count"
    t.index ["cloud_files_count"], name: "index_artists_on_cloud_files_count"
    t.index ["data_source_id"], name: "index_artists_on_data_source_id"
    t.index ["ext_id", "data_source_id"], name: "index_artists_on_ext_id_and_data_source_id"
    t.index ["ext_id"], name: "index_artists_on_ext_id"
    t.index ["misc_files_count"], name: "index_artists_on_misc_files_count"
    t.index ["peep_files_count"], name: "index_artists_on_peep_files_count"
    t.index ["releases_count"], name: "index_artists_on_releases_count"
    t.index ["video_files_count"], name: "index_artists_on_video_files_count"
  end

  create_table "buckets", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.integer "region_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "uuid"
    t.index ["region_id"], name: "index_buckets_on_region_id"
    t.index ["user_id"], name: "index_buckets_on_user_id"
    t.index ["uuid"], name: "index_buckets_on_uuid", unique: true
    t.check_constraint "uuid IS NOT NULL", name: "buckets_uuid_null"
  end

  create_table "cloud_files", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "asset"
    t.string "md5"
    t.string "content_type"
    t.bigint "filesize", default: 0
    t.text "description"
    t.float "rating"
    t.boolean "nsfw", default: false
    t.boolean "peepy", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "folder_id"
    t.string "info_url"
    t.integer "bucket_id"
    t.integer "duration", default: 0
    t.integer "settings", default: 0, null: false
    t.string "ext_id"
    t.integer "data_source_id"
    t.integer "release_id"
    t.integer "year"
    t.integer "release_pos"
    t.integer "user_id"
    t.integer "num_plays", default: 0, null: false
    t.text "state"
    t.index ["bucket_id"], name: "index_cloud_files_on_bucket_id"
    t.index ["data_source_id"], name: "index_cloud_files_on_data_source_id"
    t.index ["duration"], name: "index_cloud_files_on_duration"
    t.index ["ext_id", "data_source_id"], name: "index_cloud_files_on_ext_id_and_data_source_id"
    t.index ["ext_id"], name: "index_cloud_files_on_ext_id"
    t.index ["folder_id"], name: "index_cloud_files_on_folder_id"
    t.index ["md5", "folder_id"], name: "index_cloud_files_on_md5_and_folder_id", unique: true
    t.index ["release_id"], name: "index_cloud_files_on_release_id"
    t.index ["user_id"], name: "index_cloud_files_on_user_id"
    t.index ["year"], name: "index_cloud_files_on_year"
  end

  create_table "folders", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "ancestry"
    t.integer "bucket_id"
    t.boolean "peepy", default: false, null: false
    t.boolean "nsfw", default: false, null: false
    t.integer "cloud_files_count", default: 0, null: false
    t.integer "subfolders_count", default: 0, null: false
    t.boolean "expanded", default: false
    t.string "uuid", null: false
    t.index ["ancestry"], name: "index_folders_on_ancestry"
    t.index ["bucket_id"], name: "index_folders_on_bucket_id"
    t.index ["cloud_files_count"], name: "index_folders_on_cloud_files_count"
    t.index ["subfolders_count"], name: "index_folders_on_subfolders_count"
    t.index ["uuid"], name: "index_folders_on_uuid", unique: true
  end

  create_table "metadata", id: :serial, force: :cascade do |t|
    t.string "value"
    t.integer "user_id"
    t.integer "metadata_type_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "peepy", default: false
    t.boolean "nsfw", default: false
    t.index ["metadata_type_id"], name: "index_metadata_on_metadata_type_id"
    t.index ["user_id"], name: "index_metadata_on_user_id"
  end

  create_table "metadata_types", id: :serial, force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "metataggings", id: :serial, force: :cascade do |t|
    t.integer "cloud_file_id"
    t.integer "metadatum_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cloud_file_id"], name: "index_metataggings_on_cloud_file_id"
    t.index ["metadatum_id"], name: "index_metataggings_on_metadatum_id"
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "descr", null: false
    t.string "name", null: false
    t.string "endpoint", null: false
    t.string "location"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "release_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "releases", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "ext_id"
    t.integer "data_source_id"
    t.integer "cloud_files_count", default: 0, null: false
    t.integer "release_type_id"
    t.integer "bundle_pos", default: 1
    t.boolean "peepy", default: false
    t.boolean "nsfw", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cloud_files_count"], name: "index_releases_on_cloud_files_count"
    t.index ["data_source_id"], name: "index_releases_on_data_source_id"
    t.index ["ext_id", "data_source_id"], name: "index_releases_on_ext_id_and_data_source_id"
    t.index ["ext_id"], name: "index_releases_on_ext_id"
    t.index ["release_type_id"], name: "index_releases_on_release_type_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.string "token"
    t.string "otp_secret_key"
    t.string "access_key_id"
    t.string "secret_access_key"
    t.string "uuid", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "artist_cloud_files", "artists"
  add_foreign_key "artist_cloud_files", "cloud_files"
  add_foreign_key "artist_releases", "artists"
  add_foreign_key "artist_releases", "releases"
end
