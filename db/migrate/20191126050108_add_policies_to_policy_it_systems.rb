class AddPoliciesToPolicyITSystems < ActiveRecord::Migration[5.2]
  def change
    add_reference :policy_it_systems, :policies, foreign_key: true
  end
end
