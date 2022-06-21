class AddAttachmentResuploadToActivityControls < ActiveRecord::Migration[5.2]
  def self.up
    change_table :activity_controls do |t|
      t.attachment :resupload
    end
  end

  def self.down
    remove_attachment :activity_controls, :resupload
  end
end