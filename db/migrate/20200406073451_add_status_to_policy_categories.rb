class AddStatusToPolicyCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :policy_categories, :status, :text
    add_column :users, :status, :text
  end
end
