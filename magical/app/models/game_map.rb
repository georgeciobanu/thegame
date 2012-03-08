# == Schema Information
#
# Table name: game_maps
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  adjacency_list :text
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class GameMap < ActiveRecord::Base
  has_many :areas
  
  belongs_to :game
end
