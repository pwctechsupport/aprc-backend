class RenameControlsIdInControlBusinessProcessesToControlId < ActiveRecord::Migration[5.2]
  def change
    rename_column :control_business_processes, :controls_id, :control_id
  end
end
