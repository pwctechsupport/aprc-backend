class AddAttachmentResuploadToFileAttachments < ActiveRecord::Migration[5.2]
  def self.up
    change_table :file_attachments do |t|
      t.attachment :resupload
    end
  end

  def self.down
    remove_attachment :file_attachments, :resupload
  end
end
