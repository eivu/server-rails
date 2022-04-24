class AddUuidToUsers < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    add_column :users, :uuid, :string
    User.where(uuid: nil).each do |user|
      user.update! uuid: SecureRandom.uuid
    end
    add_index :users, :uuid, unique: true, algorithm: :concurrently
  end

  def down
    remove_column :users, :uuid
  end
end
