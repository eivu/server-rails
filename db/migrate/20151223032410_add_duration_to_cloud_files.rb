class AddDurationToCloudFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :cloud_files, :duration, :integer, :default => 0
    add_index :cloud_files, :duration
  end
end
