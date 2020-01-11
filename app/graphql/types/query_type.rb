module Types
  class QueryType < Types::BaseObject
  
    field :get_user_from_id, Types::UserType,  null: false, description: 'fetch information of user' do
      argument :id, ID, required: true
    end

    field :get_folder_from_id, [Types::ResourceType], null:false, description: 'fetch contents of folder' do
      argument :id, ID, required: false
      argument :token, String, required: false
    end

    def get_folder_from_id(**args)
      id = args[:id]
      if id.blank?
        Folder.has_content.roots.alpha + CloudFile.includes(:artists, :release).where(folder_id: nil)
      else
        Folder.has_content.where("ancestry like '%#{id}'") + CloudFile.includes(:artists, :release).where(folder_id: id).order(:release_pos)
      end
    end


    def get_user_from_id(**args)
      user_id = args[:id]
      user = User.find(user_id)
    end
  end
end
