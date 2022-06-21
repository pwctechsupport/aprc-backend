class ChangeStatusToBeStringInControls < ActiveRecord::Migration[5.2]
  def up
    change_column :controls, :status, :string, default: "draft"
  end
  
  def down
    change_column :controls, :status, :text
  end
end
