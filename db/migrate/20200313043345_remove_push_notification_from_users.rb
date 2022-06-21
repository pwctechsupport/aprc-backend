class RemovePushNotificationFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :push_notification
  end
end
