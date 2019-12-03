class RenameRisksIdInControlRisksToRiskId < ActiveRecord::Migration[5.2]
  def change
    rename_column :control_risks, :risks_id, :risk_id
  end
end
