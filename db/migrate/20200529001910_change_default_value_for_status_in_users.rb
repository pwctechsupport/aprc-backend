class ChangeDefaultValueForStatusInUsers < ActiveRecord::Migration[5.2]
  def change
    def up
      change_column_default :users, :status, "draft"
    end
  
    def down
      change_column_default :users, :status, true
    end
  end
end
