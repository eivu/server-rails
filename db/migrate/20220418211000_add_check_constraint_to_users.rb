class AddCheckConstraintToUsers < ActiveRecord::Migration[7.0]
  def change
    # begin
    add_check_constraint :users, 'uuid is null', name: 'users_uuid_null', validate: false
    # rescue ArgumentError
    # ArgumentError: Table 'users' has no check constraint for {:name=>"users_uuid_null"}
  end
end

