class AddUserIdToActivityControls < ActiveRecord::Migration[5.2]
  def change
    add_column :activity_controls, :user_id, :integer
  end
end
