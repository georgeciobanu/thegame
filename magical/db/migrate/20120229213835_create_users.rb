class CreateUsers < ActiveRecord::Migration
  def change
    
    create_table :games do |t|
      t.string :name
      
      t.timestamps
    end

    create_table :game_maps do |t|
      t.string :name
      t.text :adjacency_list
      t.integer :game_id

      t.timestamps
    end

    create_table :areas do |t|
      t.string :name
      t.float :lat
      t.float :long     
      t.integer :game_map_id
      t.integer :owner_id
      t.string :color
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height        

      t.timestamps
    end

    create_table :teams do |t|
      t.string :name
      t.integer :game_map_id
      t.string :color

      t.timestamps
    end
    add_index :teams, :name, unique: true    
    
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :team_id
      t.integer :minion_pool

      t.timestamps
    end
    
    create_table :minion_groups do |t|
      t.integer :count
      t.integer :area_id
      t.integer :user_id

      t.timestamps
    end    
    
    add_index :users, :email, unique: true
    add_column :users, :password_digest, :string
  end
end
