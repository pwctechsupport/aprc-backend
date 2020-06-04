class ChangeDefaultValueForIsSubmitted < ActiveRecord::Migration[5.2]
  def up
    change_column_default :policies, :is_submitted, false
  end

  def down
    change_column_default :policies, :is_submitted, true
  end
end
