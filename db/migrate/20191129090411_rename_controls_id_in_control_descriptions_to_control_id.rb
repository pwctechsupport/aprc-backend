class RenameControlsIdInControlDescriptionsToControlId < ActiveRecord::Migration[5.2]
  def change
    rename_column :control_descriptions, :controls_id, :control_id
  end
end
