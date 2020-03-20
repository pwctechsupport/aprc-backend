class AddRecentVisitToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :recent_visit, :datetime
  end
end
