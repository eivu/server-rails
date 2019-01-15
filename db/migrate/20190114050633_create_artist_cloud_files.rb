class CreateArtistCloudFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :artist_cloud_files do |t|
      t.references :artist, foreign_key: true
      t.references :cloud_file, foreign_key: true
      t.integer :relationship_id

      t.timestamps
    end
  end
end
