class CreateCloudFiles < ActiveRecord::Migration
  def change
    create_table :cloud_files do |t|
      t.string :name
      t.string :filename, :nil => false
      t.string :md5, :nil => false
      t.string :content_type, :nil => false
      t.text :description
      t.float :rating
      t.boolean :nsfw, :nil => false, :default => false
      t.boolean :adult, :nil => false, :default => false

      t.timestamps
    end
  end
end
