module Types
  class CloudFileType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :asset, String, null: false
    field :content_type, String, null: false
    field :release_id, Integer, null: true
    field :url, String, null: false
    field :rating, Float, null: true
    field :nsfw, Boolean, null: true
    field :peepy, Boolean, null: true
    field :info_url, String, null: true
    field :duration, Integer, null: false
    field :num_plays, Integer, null: true
    field :year, Integer, null: true
    field :release_pos, Integer, null: true
    field :artists, [Types::ArtistType], null: true
    field :release, Types::ReleaseType, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :dom_uuid, String, null: false
    field :klass, String, null: false
    field :entry_type, String, null: false
  end
end
