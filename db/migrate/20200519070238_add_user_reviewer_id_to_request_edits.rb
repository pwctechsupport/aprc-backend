class AddUserReviewerIdToRequestEdits < ActiveRecord::Migration[5.2]
  def change
    add_column :request_edits, :user_reviewer_id, :integer
  end
end
