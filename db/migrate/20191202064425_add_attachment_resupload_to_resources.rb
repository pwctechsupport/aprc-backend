class AddAttachmentResuploadToResources < ActiveRecord::Migration[5.2]
  def self.up
    change_table :resources do |t|
      t.attachment :resupload
    end
  end

  def self.down
    remove_attachment :resources, :resupload
  end
end
