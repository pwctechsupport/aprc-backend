class CreatePolicyITSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :policy_it_systems do |t|

      t.timestamps
    end
  end
end
