class AddUuidToBuckets < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    add_column :buckets, :uuid, :string
    Bucket.where(uuid: nil).each do |bucket|
      bucket.update! uuid: SecureRandom.uuid
    end
    add_index :buckets, :uuid, unique: true, algorithm: :concurrently
  end

  def down
    remove_column :buckets, :uuid
  end
end
