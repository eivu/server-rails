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
      id = args[:id]
      if id.blank?
        Folder.has_content.roots.alpha + CloudFile.includes(:artists, :release).where(folder_id: nil)
      else
        Folder.has_content.where("ancestry like '%#{id}'") + CloudFile.includes(:artists, :release).where(folder_id: id)
      end
    end


    def root
      Folder.roots.alpha
    end
  end
end
