class AddSubfoldersCountToFolders < ActiveRecord::Migration[5.2]
  def change
    add_column :folders, :subfolders_counts, :integer, :default => 0, :null => false
  end
end
