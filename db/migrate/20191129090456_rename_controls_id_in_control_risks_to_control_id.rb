class RenameControlsIdInControlRisksToControlId < ActiveRecord::Migration[5.2]
  def change
    rename_column :control_risks, :controls_id, :control_id
  end
end
