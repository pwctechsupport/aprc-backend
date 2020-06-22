class AddIsInsideToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :is_inside, :boolean, :default => false
  end
end
