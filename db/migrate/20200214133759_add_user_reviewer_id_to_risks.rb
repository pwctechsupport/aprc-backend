class AddUserReviewerIdToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :user_reviewer_id, :integer
  end
end
