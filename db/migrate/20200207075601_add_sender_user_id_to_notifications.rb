class AddSenderUserIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :sender_user_id, :integer
  end
end
