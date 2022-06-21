class AddUserReviewerIdToPolicyCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :policy_categories, :user_reviewer_id, :integer
  end
end
