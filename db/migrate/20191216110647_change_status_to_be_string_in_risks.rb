class ChangeStatusToBeStringInRisks < ActiveRecord::Migration[5.2]
  def up
    change_column :risks, :status, :string, default: "draft"
  end
  
  def down
    change_column :risks, :status, :text
  end
end
