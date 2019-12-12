class DropControlRelatedTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :control_business_processes
    drop_table :control_descriptions
    drop_table :control_risks
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
