class AddUserReviewerIdToControls < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :user_reviewer_id, :integer
  end
end
