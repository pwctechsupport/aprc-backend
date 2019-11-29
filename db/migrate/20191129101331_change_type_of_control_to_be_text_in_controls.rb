class ChangeTypeOfControlToBeTextInControls < ActiveRecord::Migration[5.2]
  def up
    change_column :controls, :type_of_control, :text
  end
  
  def down
    change_column :controls, :type_of_control, :integer
  end
end
