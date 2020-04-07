class ChangeDepartmentUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :department_id, :integer, :foreign_key => true
  end
end
