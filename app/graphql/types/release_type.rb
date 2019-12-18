module Types
  class ReleaseType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :dom_uuid, String, null: false
    field :klass, String, null: false
    field :entry_type, String, null: false
  end
end
