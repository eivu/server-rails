class AddBucketIdToFolders < ActiveRecord::Migration[5.0]
  def change
    add_column :folders, :bucket_id, :integer
    add_index :folders, :bucket_id
  end
end
