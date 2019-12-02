class AddCategoryToResources < ActiveRecord::Migration[5.2]
  def change
    add_reference :resources, :category, foreign_key: true
  end
end
