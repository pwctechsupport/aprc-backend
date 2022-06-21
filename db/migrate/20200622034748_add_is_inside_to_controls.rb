class AddIsInsideToControls < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :is_inside, :boolean, :default => false
  end
end
