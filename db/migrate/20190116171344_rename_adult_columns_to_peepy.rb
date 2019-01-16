class RenameAdultColumnsToPeepy < ActiveRecord::Migration[5.0]
  def change
    rename_column :cloud_files, :adult, :peepy
    rename_column :folders, :adult, :peepy
    rename_column :releases, :adult, :peepy
  end
end
