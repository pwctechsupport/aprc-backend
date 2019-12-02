class RemoveResourceUpdatedAtInResources < ActiveRecord::Migration[5.2]
  def change
    remove_column :resources, :resource_updated_at
  end
end
