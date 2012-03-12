# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
game = Game.create({ name: 'University of Colorado at Boulder' })
gm = GameMap.create(name: 'the one')
gm.game = game

areas = gm.areas.create([{ name: 'Sports', lat: 40.009341, long: -105.265943, owner_id: 1}, 
                         { name: 'Arts', lat: 40.009345, long: -105.265947, owner_id: 2},
                         { name: 'Science', lat: 40.009335, long: -105.265941, owner_id: 3},
                         { name: 'Engineering', lat: 40.009348, long: -105.265949, owner_id: 1} ])
                         
teams = gm.teams.create([{ name: 'Team Red' }, { name: 'Team Blue' }, { name: 'Team Green' }])

teams[0].members.create({ name: 'Liviu Chis', email: 'liviu@lindenhoney.com', password: 'liviuchis'})
teams[0].members.create({ name: 'Jonathan Cottrell', email: 'jonathan@lindenhoney.com', password: 'jonathan'})
teams[1].members.create({ name: 'Stoked Manuchau', email: 'stoked@lindenhoney.com', password: 'jonathan'})
teams[1].members.create({ name: 'Tom Forbes', email: 'tom@lindenhoney.com', password: 'tomisrich'})
teams[2].members.create({ name: 'John Doe', email: 'unknown@lindenhoney.com', password: 'johdoes'})
teams[2].members.create({ name: 'Anna Karenina', email: 'is_in_love@lindenhoney.com', password: 'jonathan'})

users = User.all

users.each do |user|
  # Each user should own a random number of areas > 1
  num_areas = Random.rand(Area.count + 1)
  
  # Each area should contain a minion group of random size, at most 100
  (1..num_areas).each do |area_id|
    user.minion_groups.create({ area_id: area_id, count: 1 + Random.rand(100)})
  end
end

