class ValidateDisallowNullUsersUuid < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :users, name: "users_uuid_null"
    change_column_null :users, :uuid, false
    remove_check_constraint :users, name: "users_uuid_null"
  end
end
