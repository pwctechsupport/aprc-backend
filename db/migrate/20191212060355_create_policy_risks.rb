class CreatePolicyRisks < ActiveRecord::Migration[5.2]
  def change
    create_table :policy_risks do |t|
      t.references :policy, foreign_key: true
      t.references :risk, foreign_key: true

      t.timestamps
    end
  end
end
