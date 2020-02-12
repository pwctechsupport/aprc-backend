class AddDraftsToUserPolicyCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :user_policy_categories, :draft_id, :integer
    add_column :user_policy_categories, :published_at, :timestamp
    add_column :user_policy_categories, :trashed_at, :timestamp
  end
end
