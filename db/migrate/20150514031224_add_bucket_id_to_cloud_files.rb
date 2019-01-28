class AddBucketIdToCloudFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :cloud_files, :bucket_id, :integer
    add_index :cloud_files, :bucket_id
  end
end
