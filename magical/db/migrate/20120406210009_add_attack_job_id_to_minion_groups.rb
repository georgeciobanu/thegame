class AddAttackJobIdToMinionGroups < ActiveRecord::Migration
  def change
    add_column :minion_groups, :delayed_job_id, :integer
    add_index(:minion_groups, :delayed_job_id, :unique => true)    

  end
end
