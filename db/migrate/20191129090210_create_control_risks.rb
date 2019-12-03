class CreateControlRisks < ActiveRecord::Migration[5.2]
  def change
    create_table :control_risks do |t|
      t.references :controls, foreign_key: true
      t.references :risks, foreign_key: true

      t.timestamps
    end
  end
end
