class AddDraftsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :draft_id, :integer
    add_column :users, :published_at, :timestamp
    add_column :users, :trashed_at, :timestamp
  end
end
