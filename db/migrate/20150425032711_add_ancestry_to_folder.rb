class AddAncestryToFolder < ActiveRecord::Migration
  def change
    add_column :folders, :ancestry, :string
    add_index :folders, :ancestry
  end
end
