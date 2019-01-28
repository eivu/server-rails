class AddEncryptedAccessKeyIdAndSecretAccessKeyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :encrypted_access_key_id, :string
    add_column :users, :encrypted_access_key_id_salt, :string
    add_column :users, :encrypted_access_key_id_iv, :string
    add_column :users, :encrypted_secret_access_key, :string
    add_column :users, :encrypted_secret_access_key_salt, :string
    add_column :users, :encrypted_secret_access_key_iv, :string
  end
end
