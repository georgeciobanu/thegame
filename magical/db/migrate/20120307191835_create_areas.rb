class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.text :shape_points
      t.integer :game_map_id

      t.timestamps
    end
  end
end