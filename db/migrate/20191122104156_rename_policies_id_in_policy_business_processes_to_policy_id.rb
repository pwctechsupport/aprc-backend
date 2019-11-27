class RenamePoliciesIdInPolicyBusinessProcessesToPolicyId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policy_business_processes, :policies_id, :policy_id
  end
end
