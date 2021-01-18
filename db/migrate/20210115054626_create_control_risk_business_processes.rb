class CreateControlRiskBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :control_risk_business_processes do |t|
      t.integer :control_id
      t.string :risk_business_process_id

      t.timestamps
    end
  end
end
