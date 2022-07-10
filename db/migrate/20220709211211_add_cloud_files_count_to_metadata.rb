class AddCloudFilesCountToMetadata < ActiveRecord::Migration[7.0]
  def change
    add_column :metadata, :cloud_files_count, :integer, null: false, default: 0
  end
end
