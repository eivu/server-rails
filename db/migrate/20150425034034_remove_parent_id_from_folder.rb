class RemoveParentIdFromFolder < ActiveRecord::Migration[5.0]
  def change
    remove_column :folders, :parent_id
  end
end
