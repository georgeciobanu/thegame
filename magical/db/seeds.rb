# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
game = Game.create({ name: 'University of Colorado at Boulder' })
gm = game.create_game_map(name: 'the one')

areas = gm.areas.create([{ name: 'Sports', lat: 33.74011, long: -84.37093, owner_id: 2, x: 180, y: 260, width: 100, height: 100 }, 
                         { name: 'Arts', lat: 33.75111, long: -84.37093, owner_id: 3, x: 360, y: 340, width: 100, height: 100 },
                         { name: 'Science', lat: 33.75111, long: -84.39593, owner_id: 1, x: 260, y: 400, width: 100, height: 100 },
                         { name: 'Engineering', lat: 33.74011, long: -84.39593, owner_id: 3, x: 280, y: 190, width: 100, height: 100 } ])

teams = gm.teams.create([{ name: 'Green', color: 'green' }, { name: 'Blue', color: 'blue' }, { name: 'Red', color: 'red' }])

Team.find(2).members.create({ name: 'Liviu Chis', email: 'liviu@lh.com', password: 'password', minion_pool: 2})
Team.find(2).members.create({ name: 'Jonathan Cottrell', email: 'jonathan@lindenhoney.com', password: 'jonathan', minion_pool: 2})
Team.find(1).members.create({ name: 'Stoked Manuchau', email: 'stoked@lindenhoney.com', password: 'jonathan', minion_pool: 2})
Team.find(1).members.create({ name: 'Tom Forbes', email: 'tom@lindenhoney.com', password: 'tomisrich', minion_pool: 2})
Team.find(3).members.create({ name: 'John Doe', email: 'unknown@lindenhoney.com', password: 'johdoes', minion_pool: 2})
Team.find(3).members.create({ name: 'Anna Karenina', email: 'is_in_love@lindenhoney.com', password: 'jonathan', minion_pool: 2})

users = User.all

user_area_mapping = {1 => [1, 2, 4], 
                 2 => [1], 
                 3 => [1, 3, 4], 
                 4 => [3], 
                 5 => [2, 3, 4], 
                 6 => [1, 4]}

user_area_mapping.each_key do |user_id|
  user_area_mapping[user_id].each do |area_id|
    User.find(user_id).minion_groups.create({ area_id: area_id, count: 3})
  end
end