class AddLastUpdatedAtToPolicy < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :last_updated_at, :datetime
  end
end
