class RenamePolicyCategoriesIdInPoliciesToPolicyCategoryId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policies, :policy_categories_id, :policy_category_id
  end
end
