class RenameITSystemsIdInPolicyITSystemsToITSystemId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policy_it_systems, :it_systems_id, :it_system_id
  end
end
