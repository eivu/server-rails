class CreateMetataggings < ActiveRecord::Migration[5.0]
  def change
    create_table :metataggings do |t|
      t.references :cloud_file, index: true
      t.references :metadatum, index: true
      t.timestamps
    end
  end
end
