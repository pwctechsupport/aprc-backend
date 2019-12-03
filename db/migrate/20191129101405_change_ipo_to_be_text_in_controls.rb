class ChangeIpoToBeTextInControls < ActiveRecord::Migration[5.2]
  def up
    change_column :controls, :ipo, :text
  end
  
  def down
    change_column :controls, :ipo, :integer
  end
end
