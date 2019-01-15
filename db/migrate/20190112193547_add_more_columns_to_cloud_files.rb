class AddMoreColumnsToCloudFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :cloud_files, :ext_id, :string
    add_column :cloud_files, :data_source_id, :integer
    add_column :cloud_files, :release_id,  :integer
    add_column :cloud_files, :year,  :integer
    add_column :cloud_files, :release_pos, :integer
    add_column :cloud_files, :user_id, :integer


    add_index :cloud_files, :release_id
    add_index :cloud_files, :user_id
    add_index :cloud_files, :year
    add_index :cloud_files, :ext_id
    add_index :cloud_files, :data_source_id
    add_index :cloud_files, [:ext_id, :data_source_id]

  end
end
