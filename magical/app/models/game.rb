# == Schema Information
#
# Table name: games
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Game < ActiveRecord::Base
  attr_accessible :name, :game_map_id
  
  validates :name, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :game_map_id, presence: true
  
  has_one :game_map
end
