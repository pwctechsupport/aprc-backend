class ChangeDefaultValueForIsAttachment < ActiveRecord::Migration[5.2]
  def up
    change_column_default :activity_controls, :is_attachment, false
  end

  def down
    change_column_default :activity_controls, :is_attachment, true
  end
end
