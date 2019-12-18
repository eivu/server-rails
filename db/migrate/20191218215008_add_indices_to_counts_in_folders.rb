class AddIndicesToCountsInFolders < ActiveRecord::Migration[5.2]
  def change
    add_index :folders, :subfolders_counts
    add_index :folders, :cloud_files_count
  end
end
