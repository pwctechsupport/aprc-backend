class CreateControls < ActiveRecord::Migration[5.2]
  def change
    create_table :controls do |t|
      t.integer :type_of_control
      t.integer :frequency
      t.integer :nature
      t.integer :assertion
      t.integer :ipo
      t.integer :control_owner
      t.integer :fte_estimate

      t.timestamps
    end
  end
end
