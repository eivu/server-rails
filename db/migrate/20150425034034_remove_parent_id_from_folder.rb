class RemoveParentIdFromFolder < ActiveRecord::Migration
  def change
    remove_column :folders, :parent_id
  end
end
