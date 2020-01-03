class ChangeDefaultValueForBusinessProcessId < ActiveRecord::Migration[5.2]
  def up
    change_column_default :risks, :business_process_id, false
  end

  def down
    change_column_default :risks, :business_process_id, true
  end
end
