class ValidateDisallowNullFoldersUuid < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :folders, name: 'folders_uuid_null'
    change_column_null :folders, :uuid, false
    remove_check_constraint :folders, name: 'folders_uuid_null'
  end
end
