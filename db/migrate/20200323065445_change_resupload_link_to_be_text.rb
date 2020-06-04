class ChangeResuploadLinkToBeText < ActiveRecord::Migration[5.2]
  def change
    change_column :resources, :resupload_link, :text
  end
end
