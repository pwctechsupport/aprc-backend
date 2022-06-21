class AddMainRoleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :main_role, :string
  end
end
