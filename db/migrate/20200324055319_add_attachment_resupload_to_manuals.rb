class AddAttachmentResuploadToManuals < ActiveRecord::Migration[5.2]
  def self.up
    change_table :manuals do |t|
      t.attachment :resupload
    end
  end

  def self.down
    remove_attachment :manuals, :resupload
  end
end
