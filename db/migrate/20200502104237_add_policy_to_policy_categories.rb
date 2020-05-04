class AddPolicyToPolicyCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :policy_categories, :policy, :text
  end
end
