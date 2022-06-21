class AddCategoryToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :category, :string
  end
end
