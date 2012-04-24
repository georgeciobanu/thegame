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

require 'spec_helper'

describe MinionGroup do
  pending "add some examples to (or delete) #{__FILE__}"
end
