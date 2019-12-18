module Types
  class FolderType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :cloud_files_count, Integer, null: false
    field :subfolders_count, Integer, null: false
    field :nsfw, Boolean, null: true
    field :peepy, Boolean, null: true
  end
end
