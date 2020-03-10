class ChangeDefaultValueForNotifShow < ActiveRecord::Migration[5.2]
  def up
    change_column_default :users, :notif_show, false
  end

  def down
    change_column_default :users, :notif_show, true
  end
end
