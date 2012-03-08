class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.float :long
      t.float :lat
      t.float :width
      t.float :height
      t.integer :game_map_id

      t.timestamps
    end
  end
end