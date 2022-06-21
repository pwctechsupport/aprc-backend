class CreateRiskBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :risk_business_processes do |t|
      t.references :risk, foreign_key: true
      t.references :business_process, foreign_key: true

      t.timestamps
    end
  end
end
