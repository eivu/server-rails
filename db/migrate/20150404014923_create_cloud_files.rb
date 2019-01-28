class CreateCloudFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :cloud_files do |t|
      t.string :name
      t.string :asset, :nil => false
      t.string :md5, :nil => false
      t.string :content_type, :nil => false
      t.integer :filesize, :nil => false, :default => 0
      t.text :description
      t.float :rating
      t.boolean :nsfw, :nil => false, :default => false
      t.boolean :adult, :nil => false, :default => false

      t.timestamps
    end
  end
end
