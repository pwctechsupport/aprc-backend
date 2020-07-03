class AddIsInsideToPolicyCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :policy_categories, :is_inside, :boolean, :default => false
    add_column :references, :is_inside, :boolean, :default => false
    add_column :resources, :is_inside, :boolean, :default => false

  end
end
