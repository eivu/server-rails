class UpdateFilesizeToBigintInCloudfiles < ActiveRecord::Migration[5.0]
  def up
    change_column :cloud_files, :filesize, :integer, :default => 0, :limit => 8
  end

  def down
    change_column :cloud_files, :filesize, :integer, :default => 0, :limit => 4
  end
end
