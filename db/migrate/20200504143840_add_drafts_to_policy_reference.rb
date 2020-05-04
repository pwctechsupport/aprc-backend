class AddDraftsToPolicyReference < ActiveRecord::Migration[5.2]
  def change
    add_column :policy_references, :draft_id, :integer
    add_column :policy_references, :published_at, :timestamp
    add_column :policy_references, :trashed_at, :timestamp
  end
end
