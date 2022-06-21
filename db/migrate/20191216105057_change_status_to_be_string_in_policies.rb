class ChangeStatusToBeStringInPolicies < ActiveRecord::Migration[5.2]
  def up
    change_column :policies, :status, :string, default: "draft"
  end
  
  def down
    change_column :policies, :status, :text
  end
end
