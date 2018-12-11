class AddInappropriateFlagsToFolder < ActiveRecord::Migration[5.0]
  def change
    add_column :folders, :adult, :boolean, :default => false, :null => false
    add_column :folders, :nsfw, :boolean, :default => false, :null => false
  end
end
