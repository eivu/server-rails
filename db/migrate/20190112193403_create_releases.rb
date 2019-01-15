class CreateReleases < ActiveRecord::Migration[5.0]
  def change
    create_table :releases do |t|
      t.string :name
      t.string :ext_id, index: true
      t.integer :data_source_id, index: true
      t.integer :cloud_files_count, default: 0, null: false
      t.integer :release_type_id
      t.integer :bundle_pos, default: 1
      t.boolean :adult
      t.boolean :nsfw

      t.timestamps
    end

    add_index :releases, :cloud_files_count
    add_index :releases, :release_type_id
    add_index :releases, [:ext_id, :data_source_id]
  end
end
