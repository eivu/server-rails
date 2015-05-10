class AddInfoUrlToCloudFiles < ActiveRecord::Migration
  def change
    add_column :cloud_files, :info_url, :string
  end
end
