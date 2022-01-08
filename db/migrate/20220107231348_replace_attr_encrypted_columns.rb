class ReplaceAttrEncryptedColumns < ActiveRecord::Migration[7.0]
  def change
    # add new columns for rails 7 encryts
    add_column :users, :access_key_id, :string
    add_column :users, :secret_access_key, :string
    # delete old columns for attr_encrypted
    remove_column :users, :encrypted_access_key_id, :string
    remove_column :users, :encrypted_access_key_id_salt, :string
    remove_column :users, :encrypted_access_key_id_iv, :string
    remove_column :users, :encrypted_secret_access_key, :string
    remove_column :users, :encrypted_secret_access_key_salt, :string
    remove_column :users, :encrypted_secret_access_key_iv, :string
  end
end
