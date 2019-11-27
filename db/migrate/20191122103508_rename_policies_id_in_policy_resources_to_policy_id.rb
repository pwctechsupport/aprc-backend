class RenamePoliciesIdInPolicyResourcesToPolicyId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policy_resources, :policies_id, :policy_id
  end
end
