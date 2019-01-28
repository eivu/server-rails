class AddFolderIdToCloudFile < ActiveRecord::Migration[5.0]
  def change
    add_column :cloud_files, :folder_id, :integer
    add_index :cloud_files, :folder_id
  end
end
