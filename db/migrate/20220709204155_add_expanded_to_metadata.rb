class AddExpandedToMetadata < ActiveRecord::Migration[7.0]
  def change
    add_column :metadata, :expanded, :boolean, default: false
  end
end
