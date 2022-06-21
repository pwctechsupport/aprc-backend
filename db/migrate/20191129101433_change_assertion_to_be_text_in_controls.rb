class ChangeAssertionToBeTextInControls < ActiveRecord::Migration[5.2]
  def up
    change_column :controls, :assertion, :text
  end
  
  def down
    change_column :controls, :assertion, :integer
  end
end
