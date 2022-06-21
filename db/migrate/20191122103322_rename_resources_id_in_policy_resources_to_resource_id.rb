class RenameResourcesIdInPolicyResourcesToResourceId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policy_resources, :resources_id, :resource_id
  end
end
