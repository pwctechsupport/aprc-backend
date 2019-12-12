class AddRiskToControls < ActiveRecord::Migration[5.2]
  def change
    add_reference :controls, :risk, foreign_key: true
  end
end
