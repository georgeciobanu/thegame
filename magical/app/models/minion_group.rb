# == Schema Information
#
# Table name: minion_groups
#
#  id            :integer(4)      not null, primary key
#  count         :integer(4)
#  area_id       :integer(4)
#  user_id       :integer(4)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  attack_job_id :integer(4)
#  lead_mg_id    :integer(4)
#

class MinionGroup < ActiveRecord::Base
  attr_accessible :count, :area_id, :user_id
  
  belongs_to :area
  belongs_to :user
  belongs_to :attack_job, :class_name => 'Delayed::Job', :foreign_key => :attack_job_id
  
  belongs_to :lead_minion_group, :class_name => 'MinionGroup'
  has_many :supporting_minion_groups, :class_name => 'MinionGroup'
  
end
