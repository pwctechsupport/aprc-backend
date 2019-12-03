class ChangeFrequencyToBeTextInControls < ActiveRecord::Migration[5.2]
  def up
    change_column :controls, :frequency, :text
  end
  
  def down
    change_column :controls, :frequency, :integer
  end
end
