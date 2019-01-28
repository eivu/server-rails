class CreateMetadataTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :metadata_types do |t|
      t.string :value

      t.timestamps
    end
  end
end
