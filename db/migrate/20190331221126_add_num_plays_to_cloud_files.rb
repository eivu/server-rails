class AddNumPlaysToCloudFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :cloud_files, :num_plays, :integer, default: 0, null: false
  end
end
