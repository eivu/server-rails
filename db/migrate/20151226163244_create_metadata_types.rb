class CreateMetadataTypes < ActiveRecord::Migration
  def change
    create_table :metadata_types do |t|
      t.string :value

      t.timestamps
    end
  end
end
