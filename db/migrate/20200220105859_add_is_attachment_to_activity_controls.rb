class AddIsAttachmentToActivityControls < ActiveRecord::Migration[5.2]
  def change
    add_column :activity_controls, :is_attachment, :boolean
  end
end
