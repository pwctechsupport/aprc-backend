class RemoveResourceContentTypeInResources < ActiveRecord::Migration[5.2]
  def change
    remove_column :resources, :resource_content_type
  end
end
