class RemoveCategoryIdInResources < ActiveRecord::Migration[5.2]
  def change
    remove_column :resources, :category_id
  end
end
