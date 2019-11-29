class RenameDescriptionsIdInControlDescriptionsToDescriptionId < ActiveRecord::Migration[5.2]
  def change
    rename_column :control_descriptions, :descriptions_id, :description_id
  end
end
