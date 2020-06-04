class AddUserReviewerIdToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :user_reviewer_id, :integer
  end
end
