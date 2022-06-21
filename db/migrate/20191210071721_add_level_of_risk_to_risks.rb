class AddLevelOfRiskToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :level_of_risk, :text
  end
end
