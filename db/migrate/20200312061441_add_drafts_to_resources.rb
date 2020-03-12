class AddDraftsToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :draft_id, :integer
    add_column :resources, :published_at, :timestamp
    add_column :resources, :trashed_at, :timestamp
  end
end
