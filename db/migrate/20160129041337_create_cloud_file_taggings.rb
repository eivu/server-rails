class CreateCloudFileTaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :cloud_file_taggings do |t|
      t.references :cloud_file, index: true
      t.references :tag, index: true

      t.timestamps
    end
  end
end
