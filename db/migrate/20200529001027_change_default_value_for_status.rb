class ChangeDefaultValueForStatus < ActiveRecord::Migration[5.2]
  def change
    def up
      change_column_default :resources, :status, "draft"
    end
  
    def down
      change_column_default :resources, :status, true
    end
  end
end
