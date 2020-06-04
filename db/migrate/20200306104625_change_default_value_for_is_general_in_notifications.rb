class ChangeDefaultValueForIsGeneralInNotifications < ActiveRecord::Migration[5.2]
  def up
    change_column_default :notifications, :is_general, false
  end

  def down
    change_column_default :notifications, :is_general, true
  end
end
