class AddVisitToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :visit, :integer, default: 0
  end
end
