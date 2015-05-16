class AddBucketIdToCloudFiles < ActiveRecord::Migration
  def change
    add_column :cloud_files, :bucket_id, :integer
    add_index :cloud_files, :bucket_id
  end
end
