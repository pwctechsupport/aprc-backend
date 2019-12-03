class CreateControlDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :control_descriptions do |t|
      t.references :controls, foreign_key: true
      t.references :descriptions, foreign_key: true

      t.timestamps
    end
  end
end
