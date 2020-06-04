class AddPushNotificationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :push_notification, :boolean
  end
end
