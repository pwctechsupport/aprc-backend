class RemovePolicyIdIdInResources < ActiveRecord::Migration[5.2]
  def change
    remove_column :resources, :policy_id_id
  end
end
