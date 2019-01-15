class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.string  :ext_id, index: true
      t.integer :data_source_id, index: true
      t.integer :cloud_files_count, default: 0, null: false
      t.integer :releases_count, default: 0, null: false
      t.integer :video_files_count, default: 0, null: false
      t.integer :audio_files_count, default: 0, null: false
      t.integer :peep_files_count, default: 0, null: false

      t.timestamps
    end
    
    add_index :artists, :cloud_files_count
    add_index :artists, :video_files_count
    add_index :artists, :audio_files_count
    add_index :artists, :peep_files_count
    add_index :artists, :releases_count
    add_index :artists, [:ext_id, :data_source_id]
  end
end
