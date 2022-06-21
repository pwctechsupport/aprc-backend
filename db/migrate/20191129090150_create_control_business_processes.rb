class CreateControlBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :control_business_processes do |t|
      t.references :controls, foreign_key: true
      t.references :business_processes, foreign_key: true

      t.timestamps
    end
  end
end
