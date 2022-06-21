class AddDraftsToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :draft_id, :integer
    add_column :policies, :published_at, :timestamp
    add_column :policies, :trashed_at, :timestamp
  end
end
