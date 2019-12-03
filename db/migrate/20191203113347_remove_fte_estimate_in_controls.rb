class RemoveFteEstimateInControls < ActiveRecord::Migration[5.2]
  def change
    remove_column :controls, :fte_estimate
  end
end
