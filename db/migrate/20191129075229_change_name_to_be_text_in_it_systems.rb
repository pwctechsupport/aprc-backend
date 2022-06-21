class ChangeNameToBeTextInITSystems < ActiveRecord::Migration[5.2]
  def up
    change_column :it_systems, :name, :text, class_name: "ItSystem", foreign_key: "name"
  end
  
  def down
    change_column :it_systems, :name, :string, class_name: "ItSystem", foreign_key: "name"
  end
end
