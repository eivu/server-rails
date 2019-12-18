module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"

    
    field :root, [Types::FolderType], null: false, description: 'Returns a list of folders located in root'
    field :get_folder_from_id, [Types::ResourceType], null:false, description: 'fetch contents of folder' do
      argument :id, ID, required: false
    end

    def get_folder_from_id(**args)
      # Folder.find_by_id(args[:id])
      if args[:id].blank?
        Folder.roots.alpha + CloudFile.where(folder_id: nil)
      end
    end


    def root
      Folder.roots
    end
  end
end
