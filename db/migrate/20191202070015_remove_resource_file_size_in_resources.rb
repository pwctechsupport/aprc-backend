class RemoveResourceFileSizeInResources < ActiveRecord::Migration[5.2]
  def change
    remove_column :resources, :resource_file_size
  end
end
