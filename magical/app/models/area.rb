# == Schema Information
#
# Table name: areas
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  lat         :float
#  long        :float
#  game_map_id :integer(4)
#  owner_id    :integer(4)
#  color       :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Area < ActiveRecord::Base
  attr_accessible :lat, :long, :name, :owner_id, :x, :y, :width, :height
  validates :width, numericality: { :greater_than => 0 }
  validates :height, numericality: { :greater_than => 0 }
  
  belongs_to :game_map
  has_many :minion_groups
  belongs_to :owner, :class_name => 'Team'
    
  def index
  end

end
