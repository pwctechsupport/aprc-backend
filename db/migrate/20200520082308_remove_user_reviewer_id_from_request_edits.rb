class RemoveUserReviewerIdFromRequestEdits < ActiveRecord::Migration[5.2]
  def change
    remove_column :request_edits, :user_reviewer_id
  end
end
