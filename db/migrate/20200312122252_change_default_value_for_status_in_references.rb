class ChangeDefaultValueForStatusInReferences < ActiveRecord::Migration[5.2]
  def up
    change_column_default :references, :status, "draft"
  end

  def down
    change_column_default :references, :status, true
  end
end
