class ChangeDefaultValueForStatusInPolicyCategories < ActiveRecord::Migration[5.2]
  def change
    def up
      change_column_default :policy_categories, :status, "draft"
    end
  
    def down
      change_column_default :policy_categories, :status, true
    end
  end
end
