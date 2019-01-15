class CreateReleaseTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :release_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
