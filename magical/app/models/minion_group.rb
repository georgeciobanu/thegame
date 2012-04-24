# == Schema Information
#
# Table name: minion_groups
#
#  id                   :integer(4)      not null, primary key
#  count                :integer(4)
#  area_id              :integer(4)
#  user_id              :integer(4)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  delayed_job_id       :integer(4)
#  lead_minion_group_id :integer(4)
#

class MinionGroup < ActiveRecord::Base
  attr_accessible :count, :area_id, :user_id
  
  belongs_to :area
  belongs_to :user
  belongs_to :delayed_job, :class_name => 'Delayed::Backend::ActiveRecord::Job', :foreign_key => :delayed_job_id
  
  belongs_to :lead_minion_group, :class_name => 'MinionGroup'
  has_many :supporting_minion_groups, :class_name => 'MinionGroup', :foreign_key => :lead_minion_group_id
  
end
