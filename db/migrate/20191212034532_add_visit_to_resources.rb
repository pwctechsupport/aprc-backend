class AddVisitToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :visit, :integer, default: 0
  end
end
