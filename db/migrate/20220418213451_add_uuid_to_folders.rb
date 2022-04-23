class AddUuidToFolders < ActiveRecord::Migration[7.0]
  def change
    add_column :folders, :uuid, :string
    Folder.where(uuid: nil).each do |folder|
      folder.update! uuid: SecureRandom.uuid
    end
  end
end
