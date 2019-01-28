class CreateBuckets < ActiveRecord::Migration[5.0]
  def change
    create_table :buckets do |t|
      t.string :name
      t.references :user, index: true
      t.references :region, index: true

      t.timestamps
    end
  end
end
