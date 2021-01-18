class AddDraftsToControlRiskBispro < ActiveRecord::Migration[5.2]
  def change
  	add_column :control_risk_business_processes, :draft_id, :integer
    add_column :control_risk_business_processes, :published_at, :timestamp
    add_column :control_risk_business_processes, :trashed_at, :timestamp
  end
end
