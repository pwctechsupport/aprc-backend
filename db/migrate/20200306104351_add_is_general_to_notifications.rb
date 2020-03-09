class AddIsGeneralToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :is_general, :boolean
  end
end
