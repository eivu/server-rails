class RenameSubfoldersCountsToSubfoldersCountInFolders < ActiveRecord::Migration[5.2]
  def change
    rename_column :folders, :subfolders_counts, :subfolders_count
  end
end
