class ChangeIsAttributesFromPolicies < ActiveRecord::Migration[5.2]
  def change
    change_column_default :policies, :is_attributes, false
  end
end
