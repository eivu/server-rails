class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :value
      t.references :user, index: true
      t.boolean :private, :default => false

      t.timestamps
    end
  end
end
