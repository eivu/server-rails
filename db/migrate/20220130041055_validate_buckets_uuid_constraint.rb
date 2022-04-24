class ValidateBucketsUuidConstraint < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :buckets, name: 'buckets_uuid_null'
  end
end
