class MinionGroup < ActiveRecord::Base
  attr_accessible :count, :area_id, :user_id
  
  belongs_to :area
  belongs_to :user
end
