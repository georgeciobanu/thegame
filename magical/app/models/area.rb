# == Schema Information
#
# Table name: areas
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  long        :float
#  lat         :float
#  width       :float
#  height      :float
#  game_map_id :integer(4)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Area < ActiveRecord::Base
  attr_accessible :lat, :long, :name
  # validates :width, numericality: { :greater_than => 0 }
  # validates :height, numericality: { :greater_than => 0 }
  
  belongs_to :game_map
end
