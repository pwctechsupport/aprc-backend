class AddTypeOfRiskToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :type_of_risk, :string
  end
end
