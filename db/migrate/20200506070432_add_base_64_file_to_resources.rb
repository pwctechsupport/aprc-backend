class AddBase64FileToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :base_64_file, :text, :limit => 4294967295
  end
end
