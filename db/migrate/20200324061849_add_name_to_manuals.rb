class AddNameToManuals < ActiveRecord::Migration[5.2]
  def change
    add_column :manuals, :name, :string
  end
end
