class AddPeepyAndNsfwToMetadata < ActiveRecord::Migration[7.0]
  def change
    add_column :metadata, :peepy, :boolean, nil: false, default: false
    add_column :metadata, :nsfw, :boolean, nil: false, default: false
  end
end
