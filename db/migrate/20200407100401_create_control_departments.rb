class CreateControlDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :control_departments do |t|
      t.references :control, foreign_key: true
      t.references :department, foreign_key: true

      t.timestamps
    end
  end
end
