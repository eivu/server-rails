class AddMd5FolderIdUniqueIndexToCloudFiles < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :cloud_files, %i[md5 folder_id], unique: true, algorithm: :concurrently
  end
end
