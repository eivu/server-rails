class DiscardOldTaggingSystem < ActiveRecord::Migration[7.0]
  def up
    drop_table(:tags, if_exists: true)
    drop_table(:cloud_file_taggings, if_exists: true)
  end

  def down
    create_table :tags do |t|
      t.string :value
      t.references :user, index: true
      t.boolean :private

      t.timestamps
    end

    create_table :cloud_file_taggings do |t|
      t.references :cloud_file, index: true
      t.references :tag, index: true

      t.timestamps
    end
  end
end
