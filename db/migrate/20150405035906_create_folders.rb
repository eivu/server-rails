class CreateFolders < ActiveRecord::Migration[5.0]
  def change
    create_table :folders do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    add_index :folders, :parent_id
  end
end
