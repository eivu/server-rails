class AddSettingsToCloudFile < ActiveRecord::Migration
  def change
    add_column :cloud_files, :settings, :integer, default: 0, null: false
  end
end
