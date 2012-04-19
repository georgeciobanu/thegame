# == Schema Information
#
# Table name: game_maps
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  adjacency_list :text
#  game_id        :integer(4)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class GameMap < ActiveRecord::Base
  has_many :areas
  has_many :teams
  
  belongs_to :game
  
  serialize :adjacency_list, Hash
end
