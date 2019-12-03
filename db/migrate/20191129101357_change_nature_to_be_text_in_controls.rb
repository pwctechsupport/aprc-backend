class ChangeNatureToBeTextInControls < ActiveRecord::Migration[5.2]
  def up
    change_column :controls, :nature, :text
  end
  
  def down
    change_column :controls, :nature, :integer
  end
end
