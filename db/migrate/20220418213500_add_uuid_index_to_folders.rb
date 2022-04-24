class AddUuidIndexToFolders < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :folders, :uuid, unique: true, algorithm: :concurrently
  end
end
