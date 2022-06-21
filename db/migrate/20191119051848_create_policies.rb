class CreatePolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :policies do |t|
      t.string :title
      t.text :description
      t.references :policy_categories, foreign_key: true

      t.timestamps
    end
  end
end
