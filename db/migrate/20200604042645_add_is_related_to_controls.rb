class AddIsRelatedToControls < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :is_related, :boolean, :default => false
    add_column :resources, :is_related, :boolean, :default => false

  end
end
