class AddStateToCloudFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :cloud_files, :state, :text
  end
end
