class RenamePoliciesIdInPolicyReferencesToPolicyId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policy_references, :policies_id, :policy_id
  end
end
