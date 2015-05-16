class AddBucketIdToFolders < ActiveRecord::Migration
  def change
    add_column :folders, :bucket_id, :integer
    add_index :folders, :bucket_id
  end
end
