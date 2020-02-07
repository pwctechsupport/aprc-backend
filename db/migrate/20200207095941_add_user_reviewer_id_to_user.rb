class AddUserReviewerIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_reviewer_id, :integer
  end
end
