class CreatePolicyReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :policy_references do |t|
      t.references :policies, foreign_key: true
      t.references :references, foreign_key: true

      t.timestamps
    end
  end
end
