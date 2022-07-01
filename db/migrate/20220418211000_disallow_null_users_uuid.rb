class DisallowNullUsersUuid < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :users, "uuid IS NOT NULL", name: "users_uuid_null", validate: false
  end
end
