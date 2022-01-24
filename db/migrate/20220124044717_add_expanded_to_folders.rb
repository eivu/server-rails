class AddExpandedToFolders < ActiveRecord::Migration[7.0]
  def change
    add_column :folders, :expanded, :boolean, default: false
  end
end
