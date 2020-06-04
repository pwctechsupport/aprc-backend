class AddDraftsToControls < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :draft_id, :integer
    add_column :controls, :published_at, :timestamp
    add_column :controls, :trashed_at, :timestamp
  end
end
