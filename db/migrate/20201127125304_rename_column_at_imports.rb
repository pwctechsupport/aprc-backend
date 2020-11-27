class RenameColumnAtImports < ActiveRecord::Migration[5.2]
  def change
  	rename_column :imports, :model_name, :name
  end
end
