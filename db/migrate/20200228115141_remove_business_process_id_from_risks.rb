class RemoveBusinessProcessIdFromRisks < ActiveRecord::Migration[5.2]
  def change
    remove_column :risks, :business_process_id
  end
end
