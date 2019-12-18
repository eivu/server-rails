module Types
  class FolderType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :cloud_files_count, Integer, null: false
    field :subfolders_count, Integer, null: false
    field :nsfw, Boolean, null: true
    field :peepy, Boolean, null: true
    field :dom_uuid, String, null: false
    field :klass, String, null: false
    field :entry_type, String, null: false
  end
end
