class AddLeadMinionGroupIdToMinionGroups < ActiveRecord::Migration
  def change
    add_column :minion_groups, :lead_minion_group_id, :integer
    add_index(:minion_groups, :lead_minion_group_id, :unique => true)    
  end
end
