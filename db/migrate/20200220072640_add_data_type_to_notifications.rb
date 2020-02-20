class AddDataTypeToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :data_type, :string
  end
end
