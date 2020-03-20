class AddRecentVisitToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :recent_visit, :datetime
  end
end
