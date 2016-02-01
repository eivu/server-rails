class CreateMetadataInstances < ActiveRecord::Migration
  def change
    create_table :metadata_instances do |t|
      t.references :cloud_file, index: true
      t.references :metadatum, index: true

      t.timestamps
    end
  end
end
