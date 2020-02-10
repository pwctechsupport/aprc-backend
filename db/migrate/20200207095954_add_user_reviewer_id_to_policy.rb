class AddUserReviewerIdToPolicy < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :user_reviewer_id, :integer
  end
end
