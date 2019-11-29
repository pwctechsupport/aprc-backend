class ChangeControlOwnerToBeTextInControls < ActiveRecord::Migration[5.2]
  def up
    change_column :controls, :control_owner, :text
  end
  
  def down
    change_column :controls, :control_owner, :integer
  end
end
