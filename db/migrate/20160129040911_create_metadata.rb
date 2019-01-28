class CreateMetadata < ActiveRecord::Migration[5.0]
  def change
    create_table :metadata do |t|
      t.string :value
      t.references :user, index: true
      t.references :metadata_type, index: true

      t.timestamps
    end
  end
end
