class AddResuploadLinkToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :resupload_link, :string
  end
end
