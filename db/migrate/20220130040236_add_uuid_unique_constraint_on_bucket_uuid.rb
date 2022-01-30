class AddUuidUniqueConstraintOnBucketUuid < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :buckets, 'uuid IS NOT NULL', name: 'buckets_uuid_null', validate: false
  end
end
