class AddFolderIdToCloudFile < ActiveRecord::Migration
  def change
    add_column :cloud_files, :folder_id, :integer
    add_index :cloud_files, :folder_id
  end
end
