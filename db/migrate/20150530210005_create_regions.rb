class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :descr, :null => false
      t.string :name, :null => false
      t.string :endpoint, :null => false
      t.string :location

      t.timestamps
    end
  end
end
