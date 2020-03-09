class ChangeDefaultValueForPushNotifications < ActiveRecord::Migration[5.2]
  def up
    change_column_default :users, :push_notification, false
  end

  def down
    change_column_default :users, :push_notification, true
  end
end
