class AddStatusToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :status, :text
  end
end
