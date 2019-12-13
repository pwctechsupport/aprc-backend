class CreatePolicyControls < ActiveRecord::Migration[5.2]
  def change
    create_table :policy_controls do |t|
      t.references :policy, foreign_key: true
      t.references :control, foreign_key: true

      t.timestamps
    end
  end
end
