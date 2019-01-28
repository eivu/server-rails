class AddInfoUrlToCloudFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :cloud_files, :info_url, :string
  end
end
