class AddLastUpdatedAtToResource < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :last_updated_at, :datetime
  end
end
