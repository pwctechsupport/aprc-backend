class ChangeDepartmentToName < ActiveRecord::Migration[5.2]
  def change
    rename_column :departments, :department, :name
  end
end
