class AddCloudFilesCountToFolders < ActiveRecord::Migration[5.0]
  def change
    add_column :folders, :cloud_files_count, :integer, :default => 0, :null => false
  end
end
