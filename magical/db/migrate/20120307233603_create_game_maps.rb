class CreateGameMaps < ActiveRecord::Migration
  def change
    create_table :game_maps do |t|
      t.string :name
      t.text :adjacency_list

      t.timestamps
    end
  end
end
