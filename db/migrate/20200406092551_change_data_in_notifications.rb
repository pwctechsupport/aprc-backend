class ChangeDataInNotifications < ActiveRecord::Migration[5.2]
  def change
    change_column :notifications, :data, :text, :limit => 4294967295
  end
end
