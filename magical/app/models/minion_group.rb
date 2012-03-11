# == Schema Information
#
# Table name: minion_groups
#
#  id         :integer(4)      not null, primary key
#  count      :integer(4)
#  area_id    :integer(4)
#  user_id    :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class MinionGroup < ActiveRecord::Base
  attr_accessible :count, :area_id, :user_id
  
  belongs_to :area
  belongs_to :user
end
