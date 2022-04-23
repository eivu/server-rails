class DisallowNullFoldersUuid < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :folders, 'uuid IS NOT NULL', name: 'folders_uuid_null', validate: false
  end
end
