class AddRoleChangeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role_change, :boolean
  end
end
