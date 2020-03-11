class AddNotifShowToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notif_show, :boolean
  end
end
