class AddITSystemsToPolicyITSystems < ActiveRecord::Migration[5.2]
  def change
    add_reference :policy_it_systems, :it_systems, foreign_key: true
  end
end
