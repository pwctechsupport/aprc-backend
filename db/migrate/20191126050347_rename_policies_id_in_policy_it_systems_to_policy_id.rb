class RenamePoliciesIdInPolicyITSystemsToPolicyId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policy_it_systems, :policies_id, :policy_id
  end
end
