class CreateResourceControls < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_controls do |t|
      t.references :resource, foreign_key: true
      t.references :control, foreign_key: true

      t.timestamps
    end
  end
end
