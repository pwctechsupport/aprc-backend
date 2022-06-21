class AddDraftToUserPolicyCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :user_policy_categories, :draft_id, :integer unless column_exists? :user_policy_categories, :draft_id
    add_column :user_policy_categories, :published_at, :timestamp unless column_exists? :user_policy_categories, :published_at
    add_column :user_policy_categories, :trashed_at, :timestamp unless column_exists? :user_policy_categories, :trashed_at
  end
end
