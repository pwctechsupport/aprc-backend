class RenameUsersIdInPoliciesToPolicyUserId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policies, :users_id, :user_id
  end
end
